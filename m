Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A46AC4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 15:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E8B2399A
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 15:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K2T+8jzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgIVPeU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:34:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51350 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgIVPeU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 11:34:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFXPNZ163847;
        Tue, 22 Sep 2020 15:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=oc+s2oDj3M2tyyz1TgJaIrqxuvA2gWQ+CNbN4CJWN6g=;
 b=K2T+8jzbcwAj41Hk45u13ZhKXtLrBa8oAP9cz+d1/XiXDSgXv1RK+LhdhoB70kYp3CU4
 zMXfm/TcoLRwdFNs0276qQ2zLNPnwnQC9yWf7JlhilQvx8L6Vr5hxEmqXYkO8m1UkBWQ
 yNJD6er5uV20v/Ppl+9Al8eUSEPW0Om4UaPgocoGcU1A7gskXtAB4jtqZtT7rpvJHcL9
 w0p1u3F4l82dvXW8IMRFFOvxgYP9YnsTH1Ld/cwfXwJQ0F+gS3A27YVqQxmCQsQQh7Es
 v0NJNuygSI8DOHlH2PRWfVUq/CizXNI8HBIo/abZ89EFMebl2ZRVKSoaybxn9Z/3llMD kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rgbumc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 15:34:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFUTbs054058;
        Tue, 22 Sep 2020 15:34:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33nurt4024-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 15:34:13 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08MFYCkI011248;
        Tue, 22 Sep 2020 15:34:12 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 08:34:12 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH 2/8] vhost: add helper to check if a vq has been setup
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <ce73f019-a247-7913-47fd-b3e5e7bdf81f@acm.org>
Date:   Tue, 22 Sep 2020 10:34:10 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <63A53BA5-653D-4DCA-88C3-812A3607FC2E@oracle.com>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
 <ce73f019-a247-7913-47fd-b3e5e7bdf81f@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 21, 2020, at 9:45 PM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>=20
> On 2020-09-21 11:23, Mike Christie wrote:
>> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
>> +{
>> +	if (vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq))
>> +		return true;
>> +	else
>> +		return false;
>> +}
>=20
> Has it been considered changing the body of this function into
> "return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq)"? =
I'm

If we do not go the VHOST_SET_VRING_ENABLE route, then I'll do what you =
suggest.


> concerned otherwise one or another build bot will suggest to make that
> change.
