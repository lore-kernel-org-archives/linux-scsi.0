Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E4AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C068F20781
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="czvSLvKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgHLTqa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:46:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60194 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgHLTqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:46:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJgx5x114882;
        Wed, 12 Aug 2020 19:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=UgltIHM6/4r83KncIXhRb+i0cqSlxWhd5XTvOBG2n3A=;
 b=czvSLvKPSElPctmhnkBgbhL0aHT7x6UY7Bgg+Q8NtUNM0kkAc1mmxlfXk3nHY81e4h/o
 tnuJCtlpdeUFHY4TKUXu9Jrtp9fsjsDLhLOq3qnv2HyFwFXwHkznmZ9QDn6GcS+ijpaI
 +4+D/GJUGoKBymT7E/pi+Tf9uhmdF3ZLVFCSzd7CIUKjvO/x6NIwAqUs2eeM5SfWbjeJ
 p6dllMbt2lwyay7VahFsAKqwL7yNClQAi6oLN1ReDexh5SuLb77bfyUG7w+9K2RJ5p07
 9at7HoL0VwAJqyWREqBvGwcXbhLBcIWBDfGo1hpnaCXD+2QrMF+xjcl7FqQag5XAyxhd Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32sm0mvtcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:46:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJhMJY109569;
        Wed, 12 Aug 2020 19:46:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32t5y7pqjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:46:28 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07CJkR3M016166;
        Wed, 12 Aug 2020 19:46:27 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:46:27 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 08/11] qla2xxx: Check if FW supports MQ before enabling
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200806111014.28434-9-njavali@marvell.com>
Date:   Wed, 12 Aug 2020 14:46:26 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: 7bit
Message-Id: <816B8E85-A56C-4DBD-A86D-122F36F090A8@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-9-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=3 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=3 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 6, 2020, at 6:10 AM, Nilesh Javali <njavali@marvell.com> wrote:
> 
> From: Saurav Kashyap <skashyap@marvell.com>
> 
> OS boot during Boot from SAN was stuck at dracut emergency shell
> after enabling nvme driver parameter. For non MQ support the driver
> was enabling MQ. Add a check to confirm if FW supports MQ.
> 
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 5 +++++
> 1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 9b59f032a569..fda812b9b564 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2017,6 +2017,11 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
> 	/* Determine queue resources */
> 	ha->max_req_queues = ha->max_rsp_queues = 1;
> 	ha->msix_count = QLA_BASE_VECTORS;
> +
> +	/* Check if FW supports MQ or not */
> +	if (!(ha->fw_attributes & BIT_6))
> +		goto mqiobase_exit;
> +
> 	if (!ql2xmqsupport || !ql2xnvmeenable ||
> 	    (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
> 		goto mqiobase_exit;
> -- 
> 2.19.0.rc0
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

