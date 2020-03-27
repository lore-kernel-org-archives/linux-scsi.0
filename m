Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27226C2D0E7
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 00:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EEC20774
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 00:59:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="prgkHMBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgC0Ayq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 20:54:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38616 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbgC0Ayq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 20:54:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R0sP84195308;
        Fri, 27 Mar 2020 00:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=21vKVjeyJEkrRpZ9G8LaF5AwEUlghChcNvG584BsqbM=;
 b=prgkHMBajO8BAbJRuv5huzoPs4arGLkBAbg8+QqxISESekh9A+DcyQDqdPKDk4l8NkZ9
 uqVXcO8bD8CSToJAjyU8tXCIkGiOS0H71NWVKTSVx6PcZq3bPhec+KYKkbgEZVFUAv+h
 2qUDj97VdEDd8dl40HQXMh37ziejK3wrfLyaRJmh9HH0cYaqiXA9VY6kh15fmScd7/lC
 7LPRuLZgCXx0xWz6cXpO6uYTCYfrCbCsu2OUgCw0eUMkqIhK6jZ8yBrsHHcqrSNzmeuX
 uerty5YkvGyyEpNhei5rzK1JzRXBRWzCvZ6sn6MfAzzglAXL1t4pH4hKKICokljY9Utk OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk3grs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 00:54:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R0qeMw081812;
        Fri, 27 Mar 2020 00:54:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3006r9dt61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 00:54:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02R0sf6F012293;
        Fri, 27 Mar 2020 00:54:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 17:54:41 -0700
To:     Bernhard Sulzer <micraft.b@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bryan Gurney <bgurney@redhat.com>
Subject: Re: Invalid optimal transfer size 33553920 accepted when physical_block_size 512
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
        <yq1o8sowfzn.fsf@oracle.com>
        <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
        <yq1pnd4tbxm.fsf@oracle.com>
        <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
        <yq1eetkrtf6.fsf@oracle.com>
        <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
        <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com>
        <yq14kugrou0.fsf@oracle.com>
        <44de25f9-2d57-e90d-7773-b060ccd55358@gmail.com>
        <yq1v9mwq82t.fsf@oracle.com>
        <4f6eb89d-57e4-a229-2e95-29fe4a691381@gmail.com>
        <yq1wo79n41a.fsf@oracle.com>
        <729da4d4-2bda-2330-dc3b-01f09973f9bd@gmail.com>
Date:   Thu, 26 Mar 2020 20:54:39 -0400
In-Reply-To: <729da4d4-2bda-2330-dc3b-01f09973f9bd@gmail.com> (Bernhard
        Sulzer's message of "Tue, 24 Mar 2020 17:14:29 +0100")
Message-ID: <yq1sghufwhc.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270006
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bernhard,

> dmesg does not seem too different, but lsblk's reporting is now correct:
>
> # lsblk -t /dev/sdc
> NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE=C2=A0 RA =
WSAME
> sdc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0 4=
096=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 4096=C2=A0=C2=A0=C2=
=A0=C2=A0 512=C2=A0=C2=A0=C2=A0 1 mq-deadline 60 128=C2=A0=C2=A0 32M
>
> Thank you so much. Any chance any of this could be backported?

Thanks for testing! It's tagged for stable.

--=20
Martin K. Petersen	Oracle Linux Engineering
