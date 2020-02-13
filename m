Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3006C3B188
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 03:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB592218AC
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 03:02:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uQ+dyeDm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgBMDCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 22:02:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:32922 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbgBMDCX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2020 22:02:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D32AML195412;
        Thu, 13 Feb 2020 03:02:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=LLzhfUkTLcL96RVaoKPShnmZ7NANy0fpYjkZKVROifY=;
 b=uQ+dyeDmJ6wPB5pK3LGgE+pkKrektaFXz12MHSbeXZ1YNpX7gdnisgU37ThSWTodnpNc
 RJofHafsz1l3FnDPvIhVsC8w8g2R8yirzlFyjOcBEAe6dHDrg+QGI7pHV1qqBQmBNWlK
 19ZwNHRjJOk7X3p/xxEJ/eDXh3v5ntp7sN8qztebQTTXlV86hi/wBUDvf8U3XqEwHEaS
 +gp4SHKAx/SNv9OvkOIS0WvZYZzp6S1SBGaVmwA+YziNs0buIiUtcvFn2j3wyVb1kq4U
 lQyo05Glgk3nXPbxDeHJ6TKOFLIGA3nvma6Bc1FiV9dw9pGxAb9ewfRdfqyvnTT0ud33 MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2y2p3spnhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 03:02:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D2vIjw131601;
        Thu, 13 Feb 2020 03:02:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2y4k9gxatq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 03:02:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01D32CWN010378;
        Thu, 13 Feb 2020 03:02:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 19:02:11 -0800
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Tim Walker <tim.t.walker@seagate.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block\@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme\@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
        <20200211122821.GA29811@ming.t460p>
        <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
        <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
Date:   Wed, 12 Feb 2020 22:02:08 -0500
In-Reply-To: <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Wed, 12 Feb 2020 01:47:53 +0000")
Message-ID: <yq1blq3rxzj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1011
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Exposing an HDD through multiple-queues each with a high queue depth
> is simply asking for troubles. Commands will end up spending so much
> time sitting in the queues that they will timeout.

Yep!

> This can already be observed with the smartpqi SAS HBA which exposes
> single drives as multiqueue block devices with high queue depth.
> Exercising these drives heavily leads to thousands of commands being
> queued and to timeouts. It is fairly easy to trigger this without a
> manual change to the QD. This is on my to-do list of fixes for some
> time now (lacking time to do it).

Controllers that queue internally are very susceptible to application or
filesystem timeouts when drives are struggling to keep up.

> NVMe HDDs need to have an interface setup that match their speed, that
> is, something like a SAS interface: *single* queue pair with a max QD
> of 256 or less depending on what the drive can take. Their is no
> TASK_SET_FULL notification on NVMe, so throttling has to come from the
> max QD of the SQ, which the drive will advertise to the host.

At the very minimum we'll need low queue depths. But I have my doubts
whether we can make this work well enough without some kind of TASK SET
FULL style AER to throttle the I/O.

> NVMe specs will need an update to have a "NONROT" (non-rotational) bit in
> the identify data for all this to fit well in the current stack.

Absolutely.

-- 
Martin K. Petersen	Oracle Linux Engineering
