From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 17:19:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210151719.27064.oliver@neukum.name>
References: <200210142107.g9EL7IX04354@localhost.localdomain> <200210150953.29905.oliver@neukum.name> <20021015143533.GA4288@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021015143533.GA4288@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, andersen@codepoet.org, linux-scsi@vger.kernel.org


> You guys aren't thinking.  Come on, what's the realistic difference in the
> hot plug user space manager in the two cases:
>
> Case 1, scsi does the attach, hot plug does the rest:
>
> hot_plug_attach_notifier(dev_t device)
> {
>   do stuff..
> }
>
> Case 2, scsi doesn't do the attach:
> hot_plug_attach_notifier(int host, int bus, int target, int lun)
> {
>   fprintf(/proc/scsi/scsi, "scsi add-single-device %d %d %d %d", host,
> bus, target, lun);
>   if(device_added_successfully) {
>     do stuff..
>   }
> }

It would have to be:
hot_plug_attach_notifier(int host, int bus, int target, int lun)
{
fprintf(/proc/scsi/scsi, "scsi add-single-device %d %d %d %d", host, bus, target, lun);
dev = find_matching_device(host, bus, target, lun);
if (!dev)
	exit();
err = check_for_device_still_present();
if (err)
	exit();
do_stuff(dev);
}

> Now, please, someone tell me why everyone is whining about user space
> doing so little to accomplish what the much larger patch that was
> posted does in kernel space?  My point is, and was, that since we need the
> user space manager *anyway* to handle things the kernel will *never*

We don't need it. We may want to have it. It works without it, not as
well, but it works.

> Besides, I've not heard anyone address my concerns about what context the
> disc attach is done in with the kernel space patch.

Shouldn't we discuss this when we conclude that it's worth doing at all?

	Regards
		Oliver


