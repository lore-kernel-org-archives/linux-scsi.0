From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] [Linux/SCSI] Add support for SPC-4 CDBs referenced
	in Persisent Reservations Allowed/Confict Table
Date: Sun, 25 Jan 2009 15:06:53 -0600
Message-ID: <1232917613.4586.11.camel@localhost.localdomain>
References: <1232612582.1274.529.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51888 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbZAYVG5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2009 16:06:57 -0500
In-Reply-To: <1232612582.1274.529.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <willy@debian.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, 2009-01-22 at 00:23 -0800, Nicholas A. Bellinger wrote:
> >From c177bb7ba55227d809d85aca3a9d4281e554f718 Mon Sep 17 00:00:00 2001
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Wed, 21 Jan 2009 22:13:00 -0800
> Subject: [PATCH 1/4] [Linux/SCSI] Add support for SPC-4 CDBs referenced in Persisent Reservations Allowed/Confict Table
> 
> This path adds support for a handful of SPC-4 CDBs, and fills out the MI_* and MO_* prefixed
> service action codes for MAINTENANCE_IN and MAINTENANCE_OUT operations.
> 
> This information is from spc4r17 and Table D.4 for MI_ and MO_ prefixed defs.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

These additions look reasonable, there are just a few semantic problems:

>  include/scsi/scsi.h |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index a109165..93af6ce 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -104,30 +104,52 @@
>  #define PERSISTENT_RESERVE_IN 0x5e
>  #define PERSISTENT_RESERVE_OUT 0x5f
>  #define VARIABLE_LENGTH_CMD   0x7f
> +#define RECEIVE_CREDENTIAL    0x7f // spc4r17 section 6.9 Table 204

Actually 0x7f isn't receive credentials, that's VARIABLE_LENGTH_CMD
(definition above) with a Service Action of 0x1800 ... it needs to be
done something like READ CAPACITY(16) is

>  #define REPORT_LUNS           0xa0
> +#define SECURITY_PROTOCOL_IN  0xa2
>  #define MAINTENANCE_IN        0xa3
>  #define MAINTENANCE_OUT       0xa4
>  #define MOVE_MEDIUM           0xa5
>  #define EXCHANGE_MEDIUM       0xa6
>  #define READ_12               0xa8
>  #define WRITE_12              0xaa
> +#define READ_MEDIA_SERIAL_NUMBER 0xab
>  #define WRITE_VERIFY_12       0xae
>  #define SEARCH_HIGH_12        0xb0
>  #define SEARCH_EQUAL_12       0xb1
>  #define SEARCH_LOW_12         0xb2
> +#define SECURITY_PROTOCOL_OUT 0xb5
>  #define READ_ELEMENT_STATUS   0xb8
>  #define SEND_VOLUME_TAG       0xb6
>  #define WRITE_LONG_2          0xea
> +#define EXTENDED_COPY         0x83
> +#define RECEIVE_COPY_RESULTS  0x84
> +#define ACCESS_CONTROL_IN     0x86
> +#define ACCESS_CONTROL_OUT    0x87
>  #define READ_16               0x88
>  #define WRITE_16              0x8a
> +#define READ_ATTRIBUTE        0x8c
> +#define WRITE_ATTRIBUTE	      0x8d
>  #define VERIFY_16	      0x8f
>  #define SERVICE_ACTION_IN     0x9e
>  /* values for service action in */
>  #define	SAI_READ_CAPACITY_16  0x10

Here ^^^^^

James


