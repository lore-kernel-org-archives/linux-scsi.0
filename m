Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A71C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 11:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B3E60FDA
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 11:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbhHQLx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 07:53:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239157AbhHQLxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 07:53:53 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HBWoLK156373;
        Tue, 17 Aug 2021 07:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3fUbLTWMuFU7LY3V1tn7jKhTCdlfvU0/mUyw+EplT1k=;
 b=RJ9Lu1+pzt1LOQO+gwHsSQSnTQzpD26NsrbIk7sRjYwJa5Z/kuf+82GXu0kRzLdSy+ee
 +3bB++jDZBo1XkP7lBWlBnTFvin1o0chstsjFBtASiUgy6daNxfACjxThu72tCcels2i
 +ccL9Gin9gHzEFZAu30DpQn45UvQ9Cp6W7w2qjsu36kFSQ/7eCPESM2HbDC5elrGRrtV
 c0d+AK3QkAQI5fmXSaxSbyTOja37ch/M00yU8VmDiirboiwnJAzmdUKRzmhxBCK3IA1V
 iyxthZMoqtH5bbtNzpaa7bNiRVIJhKs7R6Rt0EUyzjYF7Xn0KOKfuae47pKFCRz9AnSq Jw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeuctpev8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 07:53:08 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HBqr1g031737;
        Tue, 17 Aug 2021 11:53:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ae5f8c6b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 11:53:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HBr2HK58261812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 11:53:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B7E742047;
        Tue, 17 Aug 2021 11:53:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 581D74204F;
        Tue, 17 Aug 2021 11:53:02 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.145.48])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Aug 2021 11:53:02 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mFxeP-007Aau-QV; Tue, 17 Aug 2021 13:53:01 +0200
Date:   Tue, 17 Aug 2021 13:53:01 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 08/51] zfcp: open-code fc_block_scsi_eh() for host reset
Message-ID: <YRujHScPbb1Aokrj@t480-pf1aa2c2.linux.ibm.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-9-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210817091456.73342-9-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PArWZd06ptSohB9uZXctSfIIW9H4hEjN
X-Proofpoint-GUID: PArWZd06ptSohB9uZXctSfIIW9H4hEjN
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_03:2021-08-16,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 mlxlogscore=999 adultscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108170071
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 17, 2021 at 11:14:13AM +0200, Hannes Reinecke wrote:
> @@ -383,9 +385,24 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>  	}
>  	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>  	zfcp_erp_wait(adapter);
> -	fc_ret = fc_block_scsi_eh(scpnt);
> -	if (fc_ret)
> -		ret = fc_ret;
> +retry_rport_blocked:
> +	spin_lock_irqsave(host->host_lock, flags);
> +	list_for_each_entry(port, &adapter->port_list, list) {

You need to take the `adapter->port_list_lock` to iterate over the `port_list`.

i.e.: read_lock_irqsave(&adapter->port_list_lock, flags);

> +		struct fc_rport *rport = port->rport;
> +
> +		if (rport->port_state == FC_PORTSTATE_BLOCKED) {
> +			if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
> +				ret = FAST_IO_FAIL;
> +			else
> +				ret = NEEDS_RETRY;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(host->host_lock, flags);
> +	if (ret == NEEDS_RETRY) {
> +		msleep(1000);
> +		goto retry_rport_blocked;
> +	}

I really can't say I like this open coded FC code in the driver at all.

Is there a reason we can't use `fc_block_rport()` for all the rports of
the adapter?

We already do use it for other EH callbacks in the same file, and you
already look up the rports in the adapters rport-list; so using that on
the rports in the loop, instead of open-coding it doesn't seem bad? Or
is there a locking problem? 

We might waste a few cycles with that, but frankly, this is all in EH
and after adapter reset.. all performance concerns went our of the
window with that already.


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
