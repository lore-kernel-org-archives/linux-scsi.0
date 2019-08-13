Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8263BC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E66B20665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JNshO+kF";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2u2VmKMB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfHMBfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:35:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47266 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHMBfp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 21:35:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1XstV022366;
        Tue, 13 Aug 2019 01:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ejA48uEQzYmORQGanqKVrj3GWtYbx8NKxcylFPsgW/k=;
 b=JNshO+kFvImDrzL4iFLlXmVz7iAPIpgMoEHNqdV+dVr9sbbJjtwo0JdK3e9WNAoqhkhM
 nXNYuAi4H1QrwZ86cEOQgFopi+Pv2d6xU61WmdbK/6Gglj29t+IcRia2DQ+oEo38bbhP
 RcFA0dVBzsE+B+tW6+G370HMUY1N7yMec9IC6M89wHGZreW50IodWtsJS4uV0kGcPOnc
 /f2xFUOPoj6NNmSKVOFmYi61dA7kHgSZ0RbGSSedgETPHQTr/r1bPe9vZaUFsGDGo1Aq
 5Qf7TR/TpOUCPr+ydV9r2Pf5+1chJr5iBuBTecBMkb+LV0Sl6JqZvF5J0DCVULi0xlTx Ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=ejA48uEQzYmORQGanqKVrj3GWtYbx8NKxcylFPsgW/k=;
 b=2u2VmKMBLlWwGNmmfHktkidIpYwfWyJe2Y2PgtnU7H8nnPnJX1sxMhqreeJQN8EmOeNz
 LVAOPMYQ1mxVx0aU+qLCZdJ4bynzod1YQbgjmjW9Kas/5YkCuor4TnGvXtEWq4CD+gq0
 0924baouUah2HZudp6gRwEhYdcgM06PoVBIkE4WU+EwWPr6DQmAmFIAwfeHmxewJNAvp
 zPPp6ioizkn+gtVTiNzEQkRs3rnNka4Nq1+ipG1rDpxkr6JftGgulykarFJ9IjPCtiPY
 iNB1NaIHWrsPiZwRmQV4M/ok4X/i6uFpoTp3Oo2NPoVpDD/te2Ol1zr2SeTXQTbBe1BF CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp318n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:35:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1XBTI065976;
        Tue, 13 Aug 2019 01:35:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u9n9hjabq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:35:40 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D1ZdWl001141;
        Tue, 13 Aug 2019 01:35:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 18:35:38 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/58] qla2xxx patches for kernel v5.4
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190809030219.11296-1-bvanassche@acm.org>
Date:   Mon, 12 Aug 2019 21:35:36 -0400
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 8 Aug 2019 20:01:21 -0700")
Message-ID: <yq1o90t979z.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The patches in this series improve the robustness of the QLogic Fibre
> Channel initiator and target drivers. These patches are a result of
> manual code inspection, analysis of Coverity reports and stress
> testing of these two drivers. Please consider these patches for kernel
> version v5.4.

Applied to 5.4/scsi-queue. Thanks you!

-- 
Martin K. Petersen	Oracle Linux Engineering
