From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RFC] How to fix an async scan - 'rmmod --wait' race?
Date: Mon, 28 May 2012 13:58:15 +0200
Message-ID: <4FC36857.2060101@redhat.com>
References: <4F7DA4F8.90104@redhat.com> <4F86CF34.2000906@redhat.com> <4F8EF05F.8080307@redhat.com> <1337244177.2926.21.camel@dabdike.int.hansenpartnership.com> <4FB4BCEB.60506@acm.org> <1337245278.30498.2.camel@dabdike.int.hansenpartnership.com> <4FB51086.3060406@redhat.com> <1337681133.2932.4.camel@dabdike.int.hansenpartnership.com> <4FBFA18E.9040904@redhat.com> <CAA9_cmd1DF_SxJOjzZj9zFEzsbOQuq+7KQAJ56SvOuRLC-QwDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2E1L62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 May 2012 07:58:28 -0400
In-Reply-To: <CAA9_cmd1DF_SxJOjzZj9zFEzsbOQuq+7KQAJ56SvOuRLC-QwDQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <mchristi@redhat.com>, stefanr@s5r6.in-berlin.de

On 05/25/2012 08:46 PM, Dan Williams wrote:
> On Fri, May 25, 2012 at 8:13 AM, Tomas Henzl <thenzl@redhat.com> wrote:
>> May 25 04:25:54 localhost kernel: [  461.525209] BUG: unable to handle kernel NULL pointer dereference at 0000000000000079
>> May 25 04:25:54 localhost kernel: [  461.525242] IP: [<ffffffff811f0c45>] sysfs_create_dir+0x35/0xc0
> Have a look at:
>
> http://marc.info/?l=linux-scsi&m=133793175125892&w=2
>
> ...it addresses tearing down targets before they are added which
> appears to be the signature here.

Yes it helps, I can not reproduce this^ BUG any longer.

The problem I'm trying to fix can be seen when the lld is removed while
the scsi async scan is running. The reason is, that the pointers to the lld stored
in scsi_host_template are accesed even after the lld is removed.
Several possibilities how to fix this have evolved during the time the two main options
are -1) protect the scan process with try_modele_get/put, there is a problem
with 'rmmod --wait'. This seems now, with your patch, to be removed (the try_module-get-put
fix is still needed). I don't believe this is 100% safe because of the problems
in scsi_device_get. 
2) the patch posted here http://marc.info/?l=linux-scsi&m=133527313522298&w=2
it cancels the async scan, when the driver calls scsi_remove_host.(it's faster :)
I hope it is safe -I haven't seen any problems, tested without your patch.
I think your use case differs, so this patch won't fix problems you see.

--------------

>From my point of view your patch is needed and one of the two patches referenced above is needed
too, I don't care which one will be used.


Tomas


>
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


