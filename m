From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [RFC] scsi: generate uevent for SCSI sense code
Date: Mon, 15 May 2017 08:31:52 -0400
Message-ID: <1494851512.1081.28.camel@localhost.localdomain>
References: <20170504005013.2865393-1-songliubraving@fb.com>
         <20170504005013.2865393-2-songliubraving@fb.com>
         <54323B49-47CF-403A-970E-F94EDE2E0558@fb.com>
         <54b76bb9-8279-dc71-2c08-661eb3c4512f@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755038AbdEOMby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 May 2017 08:31:54 -0400
In-Reply-To: <54b76bb9-8279-dc71-2c08-661eb3c4512f@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Song Liu <songliubraving@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On Mon, 2017-05-15 at 08:04 +0200, Hannes Reinecke wrote:
> In general I like the idea; however, the 'filter' thingie is somewhat
> odd. I could somewhat buy into the idea of filtering for sense keys, but
> then I would have expected to use the 'sense_event_filter' as a bitmap
> of allowed sense keys.
> With your current design you can only filter for one specific sense key,
> _and_ you leave the remaining bits of the sense_event_filter variable
> unused.
> So either turn it into a bitmap and allow for several sense keys to be
> filtered, or treat it as mask for the _entire_ sense, but then you'd
> need for ASC and ASCQ, too.
> 
> Cheers,
> 
> Hannes

I think what would help here is understanding what you are trying to
accomplish with this change.  Are you trying to allow generation of
a uevent on a particular sense KCQ combination you know in advance,
or a set of them, or do you want to be able to normally generate
uevents for every sense keys/codes (i.e. all the bitmap bits set)
and then perhaps narrow down to a specific one when you are looking
for a problem?

When I added the sense code uevent generation for Unit Attentions,
one big concern I had was how many events per second would be generated.
The userspace event handling is very slow, and can only handle a few
hundred events per second before it starts backing up, and then you
can lose events, which you don't want.

Generating a uevent on MEDIUM ERROR is somewhat worrying, when a drive
goes bad you could easily get these on every I/O.

Your actual uevent emit:

+#ifdef CONFIG_SCSI_SENSE_UEVENT
+       case SDEV_EVT_SCSI_SENSE:
+               envp[idx++] = "SDEV_UA=SCSI_SENSE";
+               for (i = idx; i < idx + 3; ++i) {
+                       envp[i] = kzalloc(32, GFP_ATOMIC);
+                       if (!envp[i])
+                               break;
+                       free_envp = i;
+               }
+               snprintf(envp[idx++], 32, "LBA=%lu", evt->sense_evt_data.lba);
+               snprintf(envp[idx++], 32, "SIZE=%d", evt->sense_evt_data.size);
+               snprintf(envp[idx++], 32, "SENSE_CODE=%1x/%02x/%02x",
+                        evt->sense_evt_data.sshdr.sense_key,
+                        evt->sense_evt_data.sshdr.asc,
+                        evt->sense_evt_data.sshdr.ascq);
+               break;
+#endif

Is a little strange.  The "SDEV_UA" property implies that it was a
UNIT ATTENTION, but you are filtering on other sense types, so you
would probably want a different property.  Many SCSI commands do not
have a LOGICAL BLOCK ADDRESS field, or a TRANSFER LENGTH field, so
you might be reporting garbage if they don't.  And, since this is a
SCSI command, you probably want to report the length from the command,
not the count in bytes from the request structure.

So I think a customizable sense reporting feature could be very useful,
but it needs a little more development.

-Ewan
