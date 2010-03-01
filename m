From: Alexander Strakh <strakh@ispras.ru>
Subject: question about del_gendisk function use in drivers/scsi/sr.c
Date: Mon, 1 Mar 2010 18:27:41 +0000
Message-ID: <201003011827.41818.strakh@ispras.ru>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.201]:36124 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0CAP2I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Mar 2010 10:28:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Drew Eckhardt <drew@colorado.edu>, Thomas Quinot <thomas@melchior.cuivre.fdn.fr>, Gerd Knorr <kraxel@cs.tu-berlin.de>, Jens Axboe <axboe@suse.de>, Richard Gooch <rgooch@atnf.csiro.au>
Cc: Eric Youngdale <ericy@andante.org>

        KERNEL_VERSION: 2.6.33
        SUBJECT: question about del_gendisk function use
        SUBSCRIBE:
        In driver drivers/scsi/sr.c in function sr_probe:

1. In line 588 we call  alloc_disk(1);
2. If in line 593 function find_first_zero_bit returns SR_DISKS then we goto 
label fail_put (line 597).
3. In line 652 we call put_disk. But in some other drivers del_gendisk is 
called before put_disk. Why didn't we call del_gendisk before put_disk here? 
Is it an error?

570 static int sr_probe(struct device *dev)
571 {
572         struct scsi_device *sdev = to_scsi_device(dev);
573         struct gendisk *disk;
574         struct scsi_cd *cd;
575         int minor, error;
576
577         error = -ENODEV;
578         if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
579                 goto fail;
580
581         error = -ENOMEM;
582         cd = kzalloc(sizeof(*cd), GFP_KERNEL);
583         if (!cd)
584                 goto fail;
585
586         kref_init(&cd->kref);
587
588         disk = alloc_disk(1);
589         if (!disk)
590                 goto fail_free;
591
592         spin_lock(&sr_index_lock);
593         minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
594         if (minor == SR_DISKS) {
595                 spin_unlock(&sr_index_lock);
596                 error = -EBUSY;
597                 goto fail_put;
598         }

...
641                 goto fail_put;
642
643         dev_set_drvdata(dev, cd);
644         disk->flags |= GENHD_FL_REMOVABLE;
645         add_disk(disk);
646
647         sdev_printk(KERN_DEBUG, sdev,
648                     "Attached scsi CD-ROM %s\n", cd->cdi.name);
649         return 0;
650
651 fail_put:
652         put_disk(disk);
653 fail_free:
654         kfree(cd);
655 fail:
656         return error;
...
