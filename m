From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [linux-usb-devel] 2.6.9-rc4mm1:badness in	drivers/scsi/scsi_lib.c
Date: Wed, 27 Oct 2004 15:02:11 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417F2BD3.5010901@torque.net>
References: <Pine.LNX.4.44L0.0410211039420.2736-100000@ida.rowland.org>	<Pine.GSO.4.58.0410260947280.22299@boromir> <417E9163.8010904@us.ibm.com> 	<417E92AB.5020406@us.ibm.com> <1098842044.1762.688.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050506080908080403070408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:55788 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261638AbUJ0FCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 01:02:47 -0400
In-Reply-To: <1098842044.1762.688.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <mikenc@us.ibm.com>, Mateusz.Blaszczyk@nask.pl, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>

This is a multi-part message in MIME format.
--------------050506080908080403070408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Tue, 2004-10-26 at 14:08, Mike Christie wrote:
> 
>>>The null state and and oops are becuase of this
>>>http://marc.theaimsgroup.com/?l=linux-scsi&m=109733573729283&w=2
>>
>>Oh yeah. that patch is not correct, but if you correctly modify it to
>>use device_for_each_child per Christoph's suggestion, I seem to be
>>getting some refcounting errors. For some reason the sdev will be
>>released, but the sd.c still thinks it is there.
> 
> 
> Actually, he suggested using shost_for_each_device.  The reason being
> that you can't have nested device_for_each_child (because it takes the
> bus semaphore).
> 
> The attached should do this, if someone would care to try it out.
> 
> James
> 
> ===== hosts.c 1.102 vs edited =====
> --- 1.102/drivers/scsi/hosts.c	2004-10-11 10:03:45 -05:00
> +++ edited/hosts.c	2004-10-26 20:49:51 -05:00
> @@ -50,11 +50,6 @@
>  	.release	= scsi_host_cls_release,
>  };
>  
> -static int scsi_device_cancel_cb(struct device *dev, void *data)
> -{
> -	return scsi_device_cancel(to_scsi_device(dev), *(int *)data);
> -}
> -
>  /**
>   * scsi_host_cancel - cancel outstanding IO to this host
>   * @shost:	pointer to struct Scsi_Host
> @@ -62,9 +57,12 @@
>   **/
>  void scsi_host_cancel(struct Scsi_Host *shost, int recovery)
>  {
> +	struct scsi_device *sdev;
> +
>  	set_bit(SHOST_CANCEL, &shost->shost_state);
> -	device_for_each_child(&shost->shost_gendev, &recovery,
> -			      scsi_device_cancel_cb);
> +	shost_for_each_device(sdev, shost) {
> +		scsi_device_cancel(sdev, recovery);
> +	}
>  	wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
>  						&shost->shost_state)));
>  }
> 

James,
I have been seeing an oops (or badness) since about the lk 2.5
series if I left my USB Sandisk CF (ImageMate) plug in with a
mounted file system open when I halted the machine. As the logs
had already been closed down there was nothing captured.

So I thought your patch was worth a try.
This test was run on lk 2.6.10-rc1 with the above patch applied.
The result is attached.
To capture this I did the following:
   - comnected the ImageMate [became 4:0:0:0]
   - mounted a fs on it
   - echo 1 > /sys/class/scsi_device/4\:0\:0\:0/device/delete
      [lsscsi showed the device was gone after this]
   - unplugged the ImageMate (and "badness" occurred)

Doug Gilbert

--------------050506080908080403070408
Content-Type: text/plain;
 name="usb-badness_jb.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb-badness_jb.txt"

usb 2-2: USB disconnect, address 2
 4:0:0:0: Illegal state transition deleted->cancel
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1713
 [<c0236b02>] scsi_device_set_state+0x96/0xe8
 [<c0238b1c>] scsi_remove_device+0x20/0x90
 [<c0237fe7>] scsi_forget_host+0x43/0x88
 [<c0231c63>] scsi_remove_host+0xb/0x60
 [<de9ab973>] storage_disconnect+0x73/0x85 [usb_storage]
 [<de82b0e3>] usb_unbind_interface+0x6b/0x70 [usbcore]
 [<c020334f>] device_release_driver+0x4b/0x50
 [<c02034f1>] bus_remove_device+0x3d/0x6c
 [<c020286b>] device_del+0x3f/0x6c
 [<de830eef>] usb_disable_device+0xab/0xe8 [usbcore]
 [<de82ceb4>] usb_disconnect+0x88/0x138 [usbcore]
 [<de82dd55>] hub_port_connect_change+0x371/0x39c [usbcore]
 [<de82be9f>] clear_port_feature+0x2f/0x34 [usbcore]
 [<de82dfd6>] hub_events+0x256/0x374 [usbcore]
 [<de82e125>] hub_thread+0x31/0xf4 [usbcore]
 [<c0126484>] autoremove_wake_function+0x0/0x3c
 [<c0104206>] ret_from_fork+0x6/0x14
 [<c0126484>] autoremove_wake_function+0x0/0x3c
 [<de82e0f4>] hub_thread+0x0/0xf4 [usbcore]
 [<c0102179>] kernel_thread_helper+0x5/0xc
 4:0:0:0: Illegal state transition deleted->cancel
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1713
 [<c0236b02>] scsi_device_set_state+0x96/0xe8
 [<c0231a78>] scsi_device_cancel+0x1c/0xf2
 [<c0231bc3>] scsi_host_cancel+0x33/0xc8
 [<c0236b02>] scsi_device_set_state+0x96/0xe8
 [<c0238b1c>] scsi_remove_device+0x20/0x90
 [<c0231c6b>] scsi_remove_host+0x13/0x60
 [<de9ab973>] storage_disconnect+0x73/0x85 [usb_storage]
 [<de82b0e3>] usb_unbind_interface+0x6b/0x70 [usbcore]
 [<c020334f>] device_release_driver+0x4b/0x50
 [<c02034f1>] bus_remove_device+0x3d/0x6c
 [<c020286b>] device_del+0x3f/0x6c
 [<de830eef>] usb_disable_device+0xab/0xe8 [usbcore]
 [<de82ceb4>] usb_disconnect+0x88/0x138 [usbcore]
 [<de82dd55>] hub_port_connect_change+0x371/0x39c [usbcore]
 [<de82be9f>] clear_port_feature+0x2f/0x34 [usbcore]
 [<de82dfd6>] hub_events+0x256/0x374 [usbcore]
 [<de82e125>] hub_thread+0x31/0xf4 [usbcore]
 [<c0126484>] autoremove_wake_function+0x0/0x3c
 [<c0104206>] ret_from_fork+0x6/0x14
 [<c0126484>] autoremove_wake_function+0x0/0x3c
 [<de82e0f4>] hub_thread+0x0/0xf4 [usbcore]
 [<c0102179>] kernel_thread_helper+0x5/0xc

--------------050506080908080403070408--
