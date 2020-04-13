Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55E8C2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B122075E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 02:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u178Z9/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404078AbgDNCW3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 22:22:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53620 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404055AbgDNCW2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 22:22:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMEgQG131163;
        Mon, 13 Apr 2020 22:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=PoPnIdPI1aO4rszZJsXedsxdG/LSFz7LdVajhT7BURg=;
 b=u178Z9/L+VB1FBUcVh98boSUsoLW3U5R7C/vFDgyBNa1QV7pimVp3Bu3we9O+qCQiCnM
 GbWVzd+A8OEpGmlNv2gYNNXfOeY6LEoyFmco9GoqjKOwXGuxtcESwoMARqWSr+bRMRIk
 wcDcTqx5f5lP90Z0N69GyoJtB/oBTgHqoY6HYKaaDXNopV3pzdvQsZXSCBT5rUdiNdH1
 IdoXvqO5rz69zs/Nikm8CWQj/oW+z4RlgOL/RT1/bt+5fsVG5OU2l9EFH3EeX/kfUmkH
 2UEKctKsjy6+lnM9hQftxQWj8fo1T5XBul4C1lriL9mmqp6JhGfVd6xrlVEJv4sI4wR/ cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30b5ar1879-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:36:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMD50q114691;
        Mon, 13 Apr 2020 22:36:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30cta8974j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:36:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03DMar7F023224;
        Mon, 13 Apr 2020 22:36:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 15:36:52 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v4 02/14] scsi_debug: add doublestore option
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
        <20200225062351.21267-3-dgilbert@interlog.com>
Date:   Mon, 13 Apr 2020 18:36:50 -0400
In-Reply-To: <20200225062351.21267-3-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Tue, 25 Feb 2020 01:23:39 -0500")
Message-ID: <yq1tv1nvwql.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130163
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> The scsi_debug driver has always been restricted to using one (or
> none) ramdisk image for its storage. This means that thousands of
> scsi_debug devices can be created without exhausting the host
> machine's RAM. The downside is that all scsi_debug devices share the
> same ramdisk image. This option doubles the amount of ramdisk storage
> space with the first, third, fifth (etc) created scsi_debug devices
> using the first ramdisk image while the second, fourth, sixth (etc)
> created scsi_debug devices using the second ramdisk image.

I don't particularly like the idea that one has to know what first,
third, fifth, etc. are sharing backing storage and second, 24th, and
108th share a different backing.

I appreciate that % 2 is super simple. But I would much prefer to have
the backing store option be tied to a logical entity. Something like the
host, as we discussed a while back.

The default would be that all hosts share the same backing store like
they do now. And then add module parameter which allows each host to
have its own backing store. This allows greater flexibility in
configuring test setups and isn't substantially more complex than the
odd/even flip flop game, although it obviously means a bit of
fake_storep shuffling.

-- 
Martin K. Petersen	Oracle Linux Engineering
