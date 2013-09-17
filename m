From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 04/22] be2iscsi: Fix negotiated parameters upload to FW
Date: Tue, 17 Sep 2013 04:28:01 +0000
Message-ID: <00c19394-64ee-4326-8e7f-e58318974d70@CMEXHTCAS1.ad.emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
 <1379049014-32716-4-git-send-email-jayamohan.kallickal@emulex.com>
 <5237C56C.1060605@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:24671 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3IQE2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Sep 2013 00:28:07 -0400
In-Reply-To: <5237C56C.1060605@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jayamohan Kallickal <jayamohank@gmail.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sony John-N <Sony.John-N@Emulex.Com>



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Monday, September 16, 2013 7:59 PM
To: Jayamohan Kallickal
Cc: jbottomley@parallels.com; linux-scsi@vger.kernel.org; Jayamohan Kallickal; Sony John-N
Subject: Re: [PATCH 04/22] be2iscsi: Fix negotiated parameters upload to FW

On 09/13/2013 12:09 AM, Jayamohan Kallickal wrote:
>  - If target does not send MaxRecvDSL in login repsonse, then
>    initiator should consider the MaxRecvDSL for target is 8K.
>    In this scenario driver was setting the value to 64K and this
>    caused target to close cxn as data xfer was more than the
>    MaxRecvDSL
>  - Update connection offload data structure for SKH-R adapters.
> 
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_iscsi.c |    9 +++++++--
>  drivers/scsi/be2iscsi/be_main.h  |   29 ++++++++++++++++-------------
>  drivers/scsi/be2iscsi/be_mgmt.c  |    8 +++-----
>  3 files changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c 
> b/drivers/scsi/be2iscsi/be_iscsi.c
> index 2496ea7..60c1dff 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -672,9 +672,10 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
>  			session->max_burst = 262144;
>  		break;
>  	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
> -		if ((conn->max_xmit_dlength > 65536) ||
> -		    (conn->max_xmit_dlength == 0))
> +		if (conn->max_xmit_dlength > 65536)
>  			conn->max_xmit_dlength = 65536;
> +		else if (conn->max_xmit_dlength == 0)
> +			conn->max_xmit_dlength = 8192;

>Was the target sending 0 or not sending anything at all? Userspace should not be sending 0 if the target did not send >MaxRecvDSL. It looks like it should be sending 8k for that case. It looks like there is a bug in the tools where it will pass 0 >if the target sent 0.

>It seems other drivers would be hitting this bug too and we should fix everyone.

This was an IET target that  did not send any value and we were defaulting to 64K

Here is a small  userspace fix  that should  go along 

diff --git a/usr/be2iscsi.c b/usr/be2iscsi.c
index ce8b719..ba4c29f 100644
--- a/usr/be2iscsi.c
+++ b/usr/be2iscsi.c
@@ -33,10 +33,6 @@ void be2iscsi_create_conn(struct iscsi_conn *conn)
 	if (conn->max_xmit_dlength > 65536)
 		conn->max_xmit_dlength = 65536;
 
-	if (!conn_rec->iscsi.MaxXmitDataSegmentLength ||
-	    conn_rec->iscsi.MaxXmitDataSegmentLength > 65536)
-		conn_rec->iscsi.MaxXmitDataSegmentLength = 65536;
-
 	session->erl = 0;
 	session->initial_r2t_en = 1;
 }
--



