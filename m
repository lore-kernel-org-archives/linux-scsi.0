From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Sym53c8xx_2
Date: Sun, 15 Aug 2004 23:52:24 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408152344230.1714@poirot.grange>
References: <1092366037.28144.202254467@webmail.messagingengine.com>  
 <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
 <1092432298.18813.202307545@webmail.messagingengine.com>
 <Pine.LNX.4.60.0408150005570.5333@poirot.grange>
 <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:38847 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266921AbUHOVxl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Aug 2004 17:53:41 -0400
In-Reply-To: <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Kai OM <epimetreus@fastmail.fm>, linux-scsi@vger.kernel.org

On Sun, 15 Aug 2004, Kai Makisara wrote:

>> scsi(0:0:0:0): Beginning Domain Validation

...

> You missed one essential change in 2.6.6:
>
> @@ -908,6 +916,7 @@
> config SCSI_SYM53C8XX_2
>        tristate "SYM53C8XX Version 2 SCSI support"
>        depends on PCI && SCSI
> +       select SCSI_SPI_ATTRS
>
> (Many changes in sym_glue.c accompany this. You can't just remove this
> config change to try without spi.)

Yep, I could just as well just read your message:-)

Ok, some other ideas (hopefully, better ones than the first two) to try - 
do you have a chance to either connect another device to the same 
controller and / or move the device to another controller under the same 
driver? My bet would be the bug will follow the device. Just to make sure.

Then, to check which exactly command of those issued during the DV causes 
the problem, can you apply the following debugging patch and try 2.6.7 
with it? It is to be applied with -p0, note, my mail is known to mangle 
tabs, although I tested it recently and couldn't reproduce the problem. 
But if it does occur, I'll re-send it as an attachment.

Index: drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.1.1.2
diff -p -u -r1.1.1.2 scsi_transport_spi.c
--- drivers/scsi/scsi_transport_spi.c	19 May 2004 16:07:33 -0000	1.1.1.2
+++ drivers/scsi/scsi_transport_spi.c	15 Aug 2004 21:41:52 -0000
@@ -460,6 +460,7 @@ spi_dv_device_get_echo_buffer(struct scs
  		}
  	}

+	printk(KERN_WARNING"%s:%d\n", __FUNCTION__, __LINE__);
  	sreq->sr_cmd_len = 0;
  	sreq->sr_data_direction = DMA_FROM_DEVICE;

@@ -500,7 +501,7 @@ spi_dv_device_internal(struct scsi_reque
  			i->f->set_width(sdev, 0);
  		}
  	}
-
+	printk(KERN_WARNING"%s: SPI INQUIRY successful\n", __FUNCTION__);
  	if (!i->f->set_period)
  		return;

@@ -511,10 +512,13 @@ spi_dv_device_internal(struct scsi_reque
  	/* now set up to the maximum */
  	DV_SET(offset, 255);
  	DV_SET(period, 1);
+
+	printk(KERN_WARNING"%s:%d\n", __FUNCTION__, __LINE__);
  	if (!spi_dv_retrain(sreq, buffer, buffer + len,
  			    spi_dv_device_compare_inquiry))
  		return;

+	printk(KERN_WARNING"%s:%d\n", __FUNCTION__, __LINE__);
  	/* OK, now we have our initial speed set by the read only inquiry
  	 * test, now try an echo buffer test (if the device allows it) */

@@ -527,8 +531,10 @@ spi_dv_device_internal(struct scsi_reque
  		len = SPI_MAX_ECHO_BUFFER_SIZE;
  	}

+	printk(KERN_WARNING"%s:%d\n", __FUNCTION__, __LINE__);
  	spi_dv_retrain(sreq, buffer, buffer + len,
  		       spi_dv_device_echo_buffer);
+	printk(KERN_WARNING"%s:%d\n", __FUNCTION__, __LINE__);
  }


Thanks and regards 
Guennadi
---
Guennadi Liakhovetski

