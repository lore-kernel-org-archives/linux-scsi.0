From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM TOPIC] SCSI referrals support
Date: Thu, 31 Mar 2011 18:40:13 +0200
Message-ID: <AANLkTikL-EP=HsVjd_x9AmzptnrjSXdiNh3q1AriBz77@mail.gmail.com>
References: <4D385C0A.3000901@suse.de> <4D385F69.5060209@interlog.com>
 <1295541361.3014.8.camel@mulgrave.site> <4D3C100C.1010609@panasas.com> <4D3D327F.1040807@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60354 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab1CaQke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 12:40:34 -0400
Received: by vws1 with SMTP id 1so2009888vws.19
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 09:40:33 -0700 (PDT)
In-Reply-To: <4D3D327F.1040807@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@suse.de>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 24, 2011 at 9:04 AM, Hannes Reinecke <hare@suse.de> wrote:
>
> Currently sense codes have two problems:
>
> - They are limited to 96 bytes. Anything larger than that will just
> =A0be discarded (or crash with your patch above :-)
> - They inherit the same lifetime than the scsi command. But for any
> =A0decent handling you really need to push them into some
> =A0asynchronous context as you might well be within an interrupt
> =A0handler here.
>
> I'm currently working on a handling framework using relayfs
> (basically blktrace for SCSI Unit Attention); I can be doing a short
> presentation at LSF if requested.

(replying to an e-mail of two months ago)

There is another scenario where better unit attention support would
help. Both the LIO-port and the SCST-port of the ibmvstgt driver
suffer from the same race condition during reboot of the virtual I/O
server (VIOS). Since the ibmvscsic driver reconnects to the ibmvscsis
driver as soon as the ibmvscsis driver has been loaded the client
reconnects before all LUNs have been configured in the VIOS system. So
even if the target implementation generates an INQUIRY DATA HAS
CHANGED unit attention condition for each LUN change, LUNs will have
to be rescanned explicitly at the initiator side in order to get the
initiator state in sync with the target state.

Also, when using iSCSI, it would beneficial if LUN changes at the
target would result in an automatic update of the LUNs reported by the
initiator. This is not yet the case when using a Linux iSCSI initiator
because the INQUIRY DATA HAS CHANGED unit attention condition is
ignored by the Linux SCSI stack.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
