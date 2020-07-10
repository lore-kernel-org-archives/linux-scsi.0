Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B6DC433E5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 14:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7124A20663
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 14:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ww5VrBnp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgGJObP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 10:31:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32968 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGJObO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2020 10:31:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AERDxX194964;
        Fri, 10 Jul 2020 14:31:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VkeRiohi4OtuoZdm/Q+zj8sLz/dP3djaghiopoAsZYM=;
 b=Ww5VrBnph63JDUF2YGity3PYnHgtf+wTZb1P3KUIIaXMxN1OTz0sIf3+mdPDS40bF97O
 SKpcekDH+vMviompm5gLZ3o44Qn7wCokvIabXZc59F07hnlMcNbsNibzGpagEsB1t12q
 HzKEUGR76ll6uQvqSCZUnNlLUI72zyiRhzYkm0Eii7qWI14cZgZUAGcljZS7P7ONeEra
 Qux8sdFcjwYL8rzg9zfPYEgmW8ECygkNZ/YAUBW1pwf2r0P+DKOjAdgQyzM2Mb12GxXA
 raUtrlLAQaCIegXPhZkuZ3x86btnrDC9h9Y1famhKqs79fB81muBDbQsBdlUasPFyOsa hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 325y0aqsmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 14:31:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AEROje150893;
        Fri, 10 Jul 2020 14:29:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 325k3jyfx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 14:29:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06AET8gL012039;
        Fri, 10 Jul 2020 14:29:08 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jul 2020 07:29:08 -0700
Date:   Fri, 10 Jul 2020 17:29:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     varun@chelsio.com
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [bug report] scsi: cxgb4i: Add support for iSCSI segmentation
 offload
Message-ID: <20200710142903.GJ2571@kadam>
References: <20200710141729.GA135776@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710141729.GA135776@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=1
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100102
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 10, 2020 at 05:17:29PM +0300, dan.carpenter@oracle.com wrote:
> Hello Varun Prakash,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch e33c2482289b: "scsi: cxgb4i: Add support for iSCSI 
> segmentation offload" from Jun 29, 2020, leads to the following 
> Smatch complaint:
> 
>     drivers/scsi/cxgbi/libcxgbi.c:2158 cxgbi_conn_init_pdu()
>     warn: variable dereferenced before check 'tdata' (see line 2150)
> 

Same issue in cxgbi_conn_xmit_pdu() as well.

drivers/scsi/cxgbi/libcxgbi.c:2374 cxgbi_conn_xmit_pdu() warn: variable dereferenced before check 'tdata' (see line 2368)

regards,
dan carpenter

