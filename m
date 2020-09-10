Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EC2C2D0A7
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 20:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 957B821D7E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 20:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0B059hrD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgIJU7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 16:59:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgIJU72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 16:59:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AFjXMG171733;
        Thu, 10 Sep 2020 15:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=+5x2gUQKeetbIiKkBiOUWf+e3CzqLWhREe7ngH9Kgco=;
 b=0B059hrDvQs/u0QbOQqv3z0o+YT+ixzTAyxwPkjuVdyXrWcRG8PSzAi2YHW2zGhao7W0
 ACAl5iwhC+Xv0ITOfEOh+p8VlEZYquGEiNEKipbpd0ljDhsfFtbFT3Hq5mfiY756hzE8
 H6oJbkjwBEi7T7e9FwdW0DWscxLJefeTUhr+El4kSOsVbbV5J3G1nOcFzRM9P0x1k+9m
 rqEjWICr1DXkOUim6Xxn2hK5gkD9BhQ3ctY4IaZ5KHium8+xmULLoKnUpIbx0rCZcAvG
 gNVdH0rADbzz2/i/G58SuvEURcVLUADVvLUooX/P5oz6J3jwnF4HcLjVCoSUH/6h4QY4 Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33c23r91hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 15:46:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AFeRYt146570;
        Thu, 10 Sep 2020 15:46:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33cmm1902a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 15:46:07 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AFk6qV032645;
        Thu, 10 Sep 2020 15:46:06 GMT
Received: from dhcp-10-154-107-125.vpn.oracle.com (/10.154.107.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 08:46:06 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 2/3] scsi: update additional sense codes list
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200910074843.217661-3-damien.lemoal@wdc.com>
Date:   Thu, 10 Sep 2020 10:46:05 -0500
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C12140FE-7506-47DB-8B78-B38DBF3677F3@oracle.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
 <20200910074843.217661-3-damien.lemoal@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=4
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=4 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100145
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 10, 2020, at 2:48 AM, Damien Le Moal <Damien.LeMoal@wdc.com> =
wrote:
>=20
> Add missing Additional Sense Codes listed in
> http://www.t10.org/lists/asc-num.txt.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> drivers/scsi/sense_codes.h | 54 +++++++++++++++++++++++++++++++++++++-
> 1 file changed, 53 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/sense_codes.h b/drivers/scsi/sense_codes.h
> index 201a536688de..805d4c13d070 100644
> --- a/drivers/scsi/sense_codes.h
> +++ b/drivers/scsi/sense_codes.h
> @@ -1,7 +1,7 @@
> /* SPDX-License-Identifier: GPL-2.0 */
> /*
>  * The canonical list of T10 Additional Sense Codes is available at:
> - * http://www.t10.org/lists/asc-num.txt [most recent: 20141221]
> + * http://www.t10.org/lists/asc-num.txt [most recent: 20200817]
>  */
>=20
> SENSE_CODE(0x0000, "No additional sense information")
> @@ -29,6 +29,7 @@ SENSE_CODE(0x001E, "Conflicting SA creation =
request")
> SENSE_CODE(0x001F, "Logical unit transitioning to another power =
condition")
> SENSE_CODE(0x0020, "Extended copy information available")
> SENSE_CODE(0x0021, "Atomic command aborted due to ACA")
> +SENSE_CODE(0x0022, "Deferred microcode is pending")
>=20
> SENSE_CODE(0x0100, "No index/sector signal")
>=20
> @@ -72,6 +73,9 @@ SENSE_CODE(0x041F, "Logical unit not ready, =
microcode download required")
> SENSE_CODE(0x0420, "Logical unit not ready, logical unit reset =
required")
> SENSE_CODE(0x0421, "Logical unit not ready, hard reset required")
> SENSE_CODE(0x0422, "Logical unit not ready, power cycle required")
> +SENSE_CODE(0x0423, "Logical unit not ready, affiliation required")
> +SENSE_CODE(0x0424, "Depopulation in progress")
> +SENSE_CODE(0x0425, "Depopulation restoration in progress")
>=20
> SENSE_CODE(0x0500, "Logical unit does not respond to selection")
>=20
> @@ -104,6 +108,17 @@ SENSE_CODE(0x0B06, "Warning - non-volatile cache =
now volatile")
> SENSE_CODE(0x0B07, "Warning - degraded power to non-volatile cache")
> SENSE_CODE(0x0B08, "Warning - power loss expected")
> SENSE_CODE(0x0B09, "Warning - device statistics notification active")
> +SENSE_CODE(0x0B0A, "Warning - high critical temperature limit =
exceeded")
> +SENSE_CODE(0x0B0B, "Warning - low critical temperature limit =
exceeded")
> +SENSE_CODE(0x0B0C, "Warning - high operating temperature limit =
exceeded")
> +SENSE_CODE(0x0B0D, "Warning - low operating temperature limit =
exceeded")
> +SENSE_CODE(0x0B0E, "Warning - high critical humidity limit exceeded")
> +SENSE_CODE(0x0B0F, "Warning - low critical humidity limit exceeded")
> +SENSE_CODE(0x0B10, "Warning - high operating humidity limit =
exceeded")
> +SENSE_CODE(0x0B11, "Warning - low operating humidity limit exceeded")
> +SENSE_CODE(0x0B12, "Warning - microcode security at risk")
> +SENSE_CODE(0x0B13, "Warning - microcode digital signature validation =
failure")
> +SENSE_CODE(0x0B14, "Warning - physical element status change")
>=20
> SENSE_CODE(0x0C00, "Write error")
> SENSE_CODE(0x0C01, "Write error - recovered with auto reallocation")
> @@ -122,6 +137,8 @@ SENSE_CODE(0x0C0D, "Write error - not enough =
unsolicited data")
> SENSE_CODE(0x0C0E, "Multiple write errors")
> SENSE_CODE(0x0C0F, "Defects in error window")
> SENSE_CODE(0x0C10, "Incomplete multiple atomic write operations")
> +SENSE_CODE(0x0C11, "Write error - recovery scan needed")
> +SENSE_CODE(0x0C12, "Write error - insufficient zone resources")
>=20
> SENSE_CODE(0x0D00, "Error detected by third party temporary =
initiator")
> SENSE_CODE(0x0D01, "Third party device failure")
> @@ -242,6 +259,9 @@ SENSE_CODE(0x2009, "Access denied - invalid LU =
identifier")
> SENSE_CODE(0x200A, "Access denied - invalid proxy token")
> SENSE_CODE(0x200B, "Access denied - ACL LUN conflict")
> SENSE_CODE(0x200C, "Illegal command when not in append-only mode")
> +SENSE_CODE(0x200D, "Not an administrative logical unit")
> +SENSE_CODE(0x200E, "Not a subsidiary logical unit")
> +SENSE_CODE(0x200F, "Not a conglomerate logical unit")
>=20
> SENSE_CODE(0x2100, "Logical block address out of range")
> SENSE_CODE(0x2101, "Invalid element address")
> @@ -251,6 +271,8 @@ SENSE_CODE(0x2104, "Unaligned write command")
> SENSE_CODE(0x2105, "Write boundary violation")
> SENSE_CODE(0x2106, "Attempt to read invalid data")
> SENSE_CODE(0x2107, "Read boundary violation")
> +SENSE_CODE(0x2108, "Misaligned write command")
> +SENSE_CODE(0x2109, "Attempt to access gap zone")
>=20
> SENSE_CODE(0x2200, "Illegal function (use 20 00, 24 00, or 26 00)")
>=20
> @@ -275,6 +297,7 @@ SENSE_CODE(0x2405, "Security working key frozen")
> SENSE_CODE(0x2406, "Nonce not unique")
> SENSE_CODE(0x2407, "Nonce timestamp out of range")
> SENSE_CODE(0x2408, "Invalid XCDB")
> +SENSE_CODE(0x2409, "Invalid fast format")
>=20
> SENSE_CODE(0x2500, "Logical unit not supported")
>=20
> @@ -297,6 +320,10 @@ SENSE_CODE(0x260F, "Invalid data-out buffer =
integrity check value")
> SENSE_CODE(0x2610, "Data decryption key fail limit reached")
> SENSE_CODE(0x2611, "Incomplete key-associated data set")
> SENSE_CODE(0x2612, "Vendor specific key reference not found")
> +SENSE_CODE(0x2613, "Application tag mode page is invalid")
> +SENSE_CODE(0x2614, "Tape stream mirroring prevented")
> +SENSE_CODE(0x2615, "Copy source or copy destination not authorized")
> +SENSE_CODE(0x2616, "Fast copy not possible")
>=20
> SENSE_CODE(0x2700, "Write protected")
> SENSE_CODE(0x2701, "Hardware write protected")
> @@ -342,6 +369,7 @@ SENSE_CODE(0x2A12, "Data encryption parameters =
changed by vendor specific event"
> SENSE_CODE(0x2A13, "Data encryption key instance counter has changed")
> SENSE_CODE(0x2A14, "SA creation capabilities data has changed")
> SENSE_CODE(0x2A15, "Medium removal prevention preempted")
> +SENSE_CODE(0x2A16, "Zone reset write pointer recommended")
>=20
> SENSE_CODE(0x2B00, "Copy cannot execute since host cannot disconnect")
>=20
> @@ -360,6 +388,11 @@ SENSE_CODE(0x2C0B, "Not reserved")
> SENSE_CODE(0x2C0C, "Orwrite generation does not match")
> SENSE_CODE(0x2C0D, "Reset write pointer not allowed")
> SENSE_CODE(0x2C0E, "Zone is offline")
> +SENSE_CODE(0x2C0F, "Stream not open")
> +SENSE_CODE(0x2C10, "Unwritten data in zone")
> +SENSE_CODE(0x2C11, "Descriptor format sense data required")
> +SENSE_CODE(0x2C12, "Zone is inactive")
> +SENSE_CODE(0x2C13, "Well known logical unit access required")
>=20
> SENSE_CODE(0x2D00, "Overwrite error on update in place")
>=20
> @@ -395,6 +428,8 @@ SENSE_CODE(0x3100, "Medium format corrupted")
> SENSE_CODE(0x3101, "Format command failed")
> SENSE_CODE(0x3102, "Zoned formatting failed due to spare linking")
> SENSE_CODE(0x3103, "Sanitize command failed")
> +SENSE_CODE(0x3104, "Depopulation failed")
> +SENSE_CODE(0x3105, "Depopulation restoration failed")
>=20
> SENSE_CODE(0x3200, "No defect spare location available")
> SENSE_CODE(0x3201, "Defect list update failure")
> @@ -419,6 +454,7 @@ SENSE_CODE(0x3802, "Esn - power management class =
event")
> SENSE_CODE(0x3804, "Esn - media class event")
> SENSE_CODE(0x3806, "Esn - device busy class event")
> SENSE_CODE(0x3807, "Thin Provisioning soft threshold reached")
> +SENSE_CODE(0x3808, "Depopulation interrupted")
>=20
> SENSE_CODE(0x3900, "Saving parameters not supported")
>=20
> @@ -456,6 +492,7 @@ SENSE_CODE(0x3B19, "Element enabled")
> SENSE_CODE(0x3B1A, "Data transfer device removed")
> SENSE_CODE(0x3B1B, "Data transfer device inserted")
> SENSE_CODE(0x3B1C, "Too many logical objects on partition to support =
operation")
> +SENSE_CODE(0x3B20, "Element static information changed")
>=20
> SENSE_CODE(0x3D00, "Invalid bits in identify message")
>=20
> @@ -488,6 +525,11 @@ SENSE_CODE(0x3F13, "iSCSI IP address removed")
> SENSE_CODE(0x3F14, "iSCSI IP address changed")
> SENSE_CODE(0x3F15, "Inspect referrals sense descriptors")
> SENSE_CODE(0x3F16, "Microcode has been changed without reset")
> +SENSE_CODE(0x3F17, "Zone transition to full")
> +SENSE_CODE(0x3F18, "Bind completed")
> +SENSE_CODE(0x3F19, "Bind redirected")
> +SENSE_CODE(0x3F1A, "Subsidiary binding changed")
> +
> /*
>  *	SENSE_CODE(0x40NN, "Ram failure")
>  *	SENSE_CODE(0x40NN, "Diagnostic failure on component nn")
> @@ -589,6 +631,9 @@ SENSE_CODE(0x550B, "Insufficient power for =
operation")
> SENSE_CODE(0x550C, "Insufficient resources to create rod")
> SENSE_CODE(0x550D, "Insufficient resources to create rod token")
> SENSE_CODE(0x550E, "Insufficient zone resources")
> +SENSE_CODE(0x550F, "Insufficient zone resources to complete write")
> +SENSE_CODE(0x5510, "Maximum number of streams open")
> +SENSE_CODE(0x5511, "Insufficient resources to bind")
>=20
> SENSE_CODE(0x5700, "Unable to recover table-of-contents")
>=20
> @@ -692,6 +737,7 @@ SENSE_CODE(0x5D69, "Firmware impending failure =
throughput performance")
> SENSE_CODE(0x5D6A, "Firmware impending failure seek time performance")
> SENSE_CODE(0x5D6B, "Firmware impending failure spin-up retry count")
> SENSE_CODE(0x5D6C, "Firmware impending failure drive calibration retry =
count")
> +SENSE_CODE(0x5D73, "Media impending failure endurance limit met")
> SENSE_CODE(0x5DFF, "Failure prediction threshold exceeded (false)")
>=20
> SENSE_CODE(0x5E00, "Low power condition on")
> @@ -744,6 +790,8 @@ SENSE_CODE(0x6708, "Assign failure occurred")
> SENSE_CODE(0x6709, "Multiply assigned logical unit")
> SENSE_CODE(0x670A, "Set target port groups command failed")
> SENSE_CODE(0x670B, "ATA device feature not enabled")
> +SENSE_CODE(0x670C, "Command rejected")
> +SENSE_CODE(0x670D, "Explicit bind not allowed")
>=20
> SENSE_CODE(0x6800, "Logical unit not configured")
> SENSE_CODE(0x6801, "Subsidiary logical unit not configured")
> @@ -772,6 +820,10 @@ SENSE_CODE(0x6F04, "Media region code is =
mismatched to logical unit region")
> SENSE_CODE(0x6F05, "Drive region must be permanent/region reset count =
error")
> SENSE_CODE(0x6F06, "Insufficient block count for binding nonce =
recording")
> SENSE_CODE(0x6F07, "Conflict in binding nonce recording")
> +SENSE_CODE(0x6F08, "Insufficient permission")
> +SENSE_CODE(0x6F09, "Invalid drive-host pairing server")
> +SENSE_CODE(0x6F0A, "Drive-host pairing suspended")
> +
> /*
>  *	SENSE_CODE(0x70NN, "Decompression exception short algorithm id =
of nn")
>  */
> --=20
> 2.26.2
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

