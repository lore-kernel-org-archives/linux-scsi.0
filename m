Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DA6CDB465
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 17:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346344AbjJSRp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 13:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346331AbjJSRpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 13:45:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3AD131
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 10:45:23 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JHc4rW025773;
        Thu, 19 Oct 2023 17:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=WPqNp0mvFxVH9DrxVyDxAqsLBgSZEShO3hYrsxvxbwg=;
 b=G7DYeCLa72GFxvsf8Z6WGbhtXsB4uQBVW6WlC2MvgmibTu+/pcB6UlCCiZZPHEjgem8c
 0cQDS58FoEE9a7nXuht1gE7IRSCUat79MxH/Vwgw3J4o+qmwNnHAXNiQHuo0Fl3vgXEg
 lAPEcEELkQOgVkLsh/P1HiFJgxi2B5r+Q1j39YsZL+koOu9cuWN3NWvyrcgWoEdKet90
 ZWp62sihFAk0uZymLGYrT/RJ3ihCtregfrTcGKBUWDGfIJSkvvpFcFXkz0z7qvNoDaAI
 A77tM9uLViDVca77eamJu53XBaDnzBLhX0FEXiB3te7kDtBuysYc6UJ7iU5sfzmLX8n7 rA== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu91786cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 17:44:38 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39JFjvAG019713;
        Thu, 19 Oct 2023 17:44:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tr8122053-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 17:44:29 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39JHiQa022675980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 17:44:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA59A20043;
        Thu, 19 Oct 2023 17:44:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B54720040;
        Thu, 19 Oct 2023 17:44:26 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.54])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 19 Oct 2023 17:44:26 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qtX4M-008PH4-1H;
        Thu, 19 Oct 2023 19:44:26 +0200
Date:   Thu, 19 Oct 2023 19:44:26 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 01/16] zfcp: do not wait for rports to become unblocked
 after host reset
Message-ID: <20231019174426.GA1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231017100729.123506-1-hare@suse.de>
 <20231017100729.123506-2-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231017100729.123506-2-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AxIY0cJOvnJln41pjqwWiQNoROY6OVdw
X-Proofpoint-ORIG-GUID: AxIY0cJOvnJln41pjqwWiQNoROY6OVdw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_17,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310190150
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Hannes,

On Tue, Oct 17, 2023 at 12:07:14PM +0200, Hannes Reinecke wrote:
> zfcp_scsi_eh_host_reset_handler() would call fc_block_rport() to
> wait for all rports to become unblocked after host reset.
> But after host reset it might happen that the port is gone, hence
> fc_block_rport() might fail due to a missing port.
> But that's a perfectly legal operation; on FC remote ports might
> come and go.
> So this patch removes the call to fc_block_rport() after host
> reset. But with that rports may still be in blocked state after
> host reset, so we need to return FAST_IO_FAIL from host reset
> to avoid SCSI EH to fail commands prematurely if the rports
> are still blocked.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Steffen Maier <maier@linux.ibm.com
> Cc: Benjamin Block <bblock@linux.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_scsi.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index b2a8cd792266..b1df853e6f66 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -375,7 +375,7 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>  {
>  	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
>  	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> -	int ret = SUCCESS, fc_ret;
> +	int ret = FAST_IO_FAIL;

One thing I noticed, `scsi_ioctl_reset()` doesn't handle FAST_IO_FAIL at all;
it just considers that a failure, and returns EIO to userspace. I wonder if
this is appropriate after what we've discussed. In our case FAST_IO_FAIL
doesn't mean the host reset failed.

I don't think we need to adapt this patch for that - couldn't really - but
maybe there should be an extra change for that. Not exactly sure what even
uses that IOCTL interface, and how it'd react to an EIO.

>  
>  	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
>  		zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
> @@ -383,10 +383,6 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>  	}
>  	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>  	zfcp_erp_wait(adapter);
> -	fc_ret = fc_block_scsi_eh(scpnt);
> -	if (fc_ret)
> -		ret = fc_ret;
> -
>  	zfcp_dbf_scsi_eh("schrh_r", adapter, ~0, ret);
>  	return ret;
>  }

I think this works for us. Thanks.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
