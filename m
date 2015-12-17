From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 3/3] block: Export max_dev_sectors_kb in sysfs
Date: Thu, 17 Dec 2015 04:03:25 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEB901E@G9W0745.americas.hpqcorp.net>
References: <1450306433-20166-1-git-send-email-martin.petersen@oracle.com>
 <1450306433-20166-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:33350 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbbLQEF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 23:05:28 -0500
In-Reply-To: <1450306433-20166-3-git-send-email-martin.petersen@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>



> -----Original Message-----
> From: linux-block-owner@vger.kernel.org [mailto:linux-block-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Wednesday, December 16, 2015 4:54 PM
> To: linux-scsi@vger.kernel.org; linux-block@vger.kernel.org
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Subject: [PATCH 3/3] block: Export max_dev_sectors_kb in sysfs
> 
...
> diff --git a/Documentation/block/queue-sysfs.txt
...
> @@ -55,9 +55,15 @@ logical_block_size (RO)
>  -----------------------
>  This is the logcal block size of the device, in bytes.

Since you're in the vicinity, consider adding an i to logcal.
> 
> +max_dev_sectors_kb (R)
> +----------------------

The others use (RO) rather than just (R).

> +This is the maximum number of kilobytes supported by the storage
> +device for a READ or WRITE request.
> +
>  max_hw_sectors_kb (RO)
>  ----------------------
> -This is the maximum number of kilobytes supported in a single data transfer.
> +This is the maximum number of kilobytes supported by the storage
> +controller in a single data transfer.
...
> @@ -68,7 +74,8 @@ max_sectors_kb (RW)
>  -------------------
>  This is the maximum number of kilobytes that the block layer will allow
>  for a filesystem request. Must be smaller than or equal to the maximum
> -size allowed by the hardware.
> +size allowed by the storage controller (max_hw_sectors_kb) and the
> +maximum size allowed by the storage device (max_dev_sectors_kb).

Each one uses a different phrase:
* for a READ or WRITE request
* in a single data transfer
* for a filesystem request

Is some subtle difference being implied?


Since there are existing sysfs file with similar names, you're
stuck using _kb for the new one.  However, I suggest that the
Documentation at least mention these are really KiB, not kilobyte,
units.

---
Robert Elliott, HPE Persistent Memory


