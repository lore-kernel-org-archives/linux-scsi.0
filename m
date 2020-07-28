Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FC7C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 08:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4D12206D7
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 08:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kMgubnmU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgG1ImA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 04:42:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgG1ImA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 04:42:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S8bbMY129456;
        Tue, 28 Jul 2020 08:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=z486fM3ZhuFnXdp1xbJVRVkSwBqhKdWlnxMDY3kdnag=;
 b=kMgubnmUmgo7kM82YyziHNH1ujv8Uv2jAZi1T2EEy+yUE2YMEDMtvYIjtc4j1ltM3TT+
 wWgKvMpq3twx7nzMB/+MpXMkL6MHMNj2zV8/vBNn7U6YcijuRC744xqVuU8KeYLobt1C
 u2YhhHLxwHZ8gbKk+wmgXUDEBaI1ozcXnA8OSLfZVdYTE33IDCIqIQcQ4LDoSvI+dF2w
 N0JR5G/hxcbZePeWAx+hE1VoMpHx10q44S18xyVX0KsIxNwtekcaGkq/o/60AYs4WyUH
 D07j6qKhL/q4mABUrYalC2ZsOK3dJzlg9gcyhXg/RnTTLRI/qYo2gICx16+L4Me2Ab5r Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32hu1je402-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Jul 2020 08:41:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06S8cirs084276;
        Tue, 28 Jul 2020 08:41:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32hu5tu5a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jul 2020 08:41:50 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06S8fkYw030454;
        Tue, 28 Jul 2020 08:41:46 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 01:41:45 -0700
Date:   Tue, 28 Jul 2020 11:41:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH] scsi/megaraid: Prevent
 kernel-infoleak in kioc_to_mimd()
Message-ID: <20200728084137.GC2571@kadam>
References: <20200727210235.327835-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727210235.327835-1-yepeilin.cs@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280065
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 27, 2020 at 05:02:35PM -0400, Peilin Ye wrote:
> hinfo_to_cinfo() does no operation on `cinfo` when `hinfo` is NULL,
> causing kioc_to_mimd() to copy uninitialized stack memory to userspace.
> Fix it by initializing `cinfo` with memset().

But "hinfo" can't be NULL so this patch isn't required.  It's a bit
hard for Smatch to follow the code.

We know that "opcode" is 82 so the buffer is allocated by mimd_to_kioc()
-> mraid_mm_attach_buf().

Generally, don't silence static checker warnings unless it makes the
code more readable.  It's the checker writer's job to fix their own code.
In this case, that's me, but parsing the code is quite complicated and I
don't have a plan for how to fix it.

regards,
dan carpenter

