From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Wed, 22 Feb 2006 09:36:58 +0100
Message-ID: <20060222083657.GA24802@suse.de>
References: <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de> <43ED1FE0.1000805@us.ibm.com> <20060210232935.GA27760@suse.de> <43FA49F9.4020309@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:18847 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932514AbWBVIhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 03:37:06 -0500
Content-Disposition: inline
In-Reply-To: <43FA49F9.4020309@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

 On Mon, Feb 20, Brian King wrote:

> Olaf Hering wrote:
> > 1:mon> d c0000000024cacc8
> > c0000000024cacc8 00000000dead4ead ffffffff00000000  |......N.........|
> > c0000000024cacd8 ffffffffffffffff c0000000024cace0  |.............L..|
> > c0000000024cace8 c0000000024cace0 c000000000614f68  |.....L.......aOh|
> > c0000000024cacf8 c000000000614f38 0000000000000000  |.....aO8........|
> > c0000000024cad08 0000000000000000 0000000000000000  |................|
> > c0000000024cad18 0000000000000000 0000000000000000  |................|
> > c0000000024cad28 0000000000000000 0000000000000000  |................|
> > c0000000024cad38 0000000000000000 0000000000000000  |................|
> > c0000000024cad48 0000000000000000 0000000000000000  |................|
> > c0000000024cad58 0000000000000000 0000000000000000  |................|
> > c0000000024cad68 0000000000000000 0000000000000000  |................|
> > c0000000024cad78 0000000000000000 0000000000000000  |................|
> > c0000000024cad88 0000000000000000 0000000000000000  |................|
> > c0000000024cad98 0000000000000000 0000000000000000  |................|
> > c0000000024cada8 0000000000000000 0000000000000000  |................|
> > c0000000024cadb8 0000000000000000 0000000000000000  |................|
> > c0000000024cadc8 0000000000000000 0000000000000000  |................|
> > c0000000024cadd8 0000000000000000 0000000000000000  |................|
> 
> I've now seen a couple recreates of this problem on various systems in
> our labs, and there are always a bunch of zeroes in the struct device
> in the same place as above. I wonder if perhaps the call to device_add
> is failing in scsi_alloc_target. Failure of this call is not being handled
> today. Can you give the attached patch a try? 

This fixes it, tested with plain rc3. Lots of -EEXIST, I wonder if the real bug is elsewhere.

cat /root/rocket/cranberry_full.20.log | strings | env -i  grep -w device_add | sort | uniq -c
      2 scsi_alloc_target(367): device_add for 'target0:255:107' failed with -17
      3 scsi_alloc_target(367): device_add for 'target0:255:110' failed with -17
      3 scsi_alloc_target(367): device_add for 'target0:255:114' failed with -17
      2 scsi_alloc_target(367): device_add for 'target0:255:37' failed with -17
      1 scsi_alloc_target(367): device_add for 'target0:255:39' failed with -17


@@ -361,7 +362,17 @@ static struct scsi_target *scsi_alloc_ta
        spin_unlock_irqrestore(shost->host_lock, flags);
        /* allocate and add */
        transport_setup_device(dev);
-       device_add(dev);
+       err = device_add(dev);
+       if (err) {
+               printk(KERN_EMERG "%s(%u): device_add for '%s' failed with %d\n",__FUNCTION__,__LINE__,dev->bus_id,err);
+               spin_lock_irqsave(shost->host_lock, flags);
+               list_del_init(&starget->siblings);
+               spin_unlock_irqrestore(shost->host_lock, flags);
+               transport_destroy_device(dev);
+               put_device(parent);
+               kfree(starget);
+               return NULL;
+       }
        transport_add_device(dev);

