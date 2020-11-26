Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C398FC56202
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 15:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B7D21D1A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 15:13:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lir9ziI2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391239AbgKZPNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 10:13:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389316AbgKZPNH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Nov 2020 10:13:07 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQF2KPp010743;
        Thu, 26 Nov 2020 10:12:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=24ioQCaQnbpaw4ZzpAU/UlSxiu/85955NmGjGmE/f+U=;
 b=lir9ziI2xN6ift3gK7vPK6SKtD248KuN8KCZ56ZiPXQbup5PUuRLc3WNo17xYYgm7N6J
 3uoRy9ZZAjK7DzamFKyBNWG1pvRRcLtqGp2OGx0/fCnbThaJIcKVriuRSbaVKWqTwEc9
 zLEjHSj9D9HNBEotmSOyVGafwKY2guJIWXaKZUUi0y0oPYr279nEeLc22tH3mn5azE44
 4kYv58HBrVnCb6oNd3qq3Tm1WtyqgUybytubgFAZP6d8YU21NIQD6fAzY3AYQHtgPfxI
 n2cT/SNF4LZ1NrhDRc5EQ5s48cOFnHGEWzcxyov+ieK/zNVt1hXCbNyudxDXZS11AHA4 zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352ccemeyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 10:12:51 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AQF2OwB011245;
        Thu, 26 Nov 2020 10:12:51 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352ccemexc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 10:12:51 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQF6re1031217;
        Thu, 26 Nov 2020 15:12:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 352ata03v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 15:12:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQFCjmK8651342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 15:12:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3C6611C04C;
        Thu, 26 Nov 2020 15:12:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BEC611C058;
        Thu, 26 Nov 2020 15:12:45 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.178.201])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 26 Nov 2020 15:12:45 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kiIwt-002zEL-1k; Thu, 26 Nov 2020 16:12:43 +0100
Date:   Thu, 26 Nov 2020 16:12:42 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: zfcp: fix use-after-free in zfcp_unit_remove
Message-ID: <20201126151242.GI8578@t480-pf1aa2c2>
References: <20201120074854.31754-1-miaoqinglang@huawei.com>
 <20201125170658.GB8578@t480-pf1aa2c2>
 <4c65bead-2553-171e-54d2-87a9de0330e8@huawei.com>
 <20201126091353.50cf6ab6.cohuck@redhat.com>
 <20201126094259.GE8578@t480-pf1aa2c2>
 <9ba663ad-97fe-6c2a-e15a-45f2de1f0af0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ba663ad-97fe-6c2a-e15a-45f2de1f0af0@huawei.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_04:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2020 at 08:07:32PM +0800, Qinglang Miao wrote:
> 在 2020/11/26 17:42, Benjamin Block 写道:
> > On Thu, Nov 26, 2020 at 09:13:53AM +0100, Cornelia Huck wrote:
> > > On Thu, 26 Nov 2020 09:27:41 +0800
> > > Qinglang Miao <miaoqinglang@huawei.com> wrote:
> > > > 在 2020/11/26 1:06, Benjamin Block 写道:
> > > > > On Fri, Nov 20, 2020 at 03:48:54PM +0800, Qinglang Miao wrote:
....
> > Let's go by example. If we assume the reference count of `unit->dev` is
> > R, and the function starts with R = 1 (otherwise the deivce would've
> > been freed already), we get:
> > 
> >      int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
> >      {
> >      	struct zfcp_unit *unit;
> >      	struct scsi_device *sdev;
> >      	write_lock_irq(&port->unit_list_lock);
> > // unit->dev (R = 1)
> >      	unit = _zfcp_unit_find(port, fcp_lun);
> > // get_device(&unit->dev)
> > // unit->dev (R = 2)
> >      	if (unit)
> >      		list_del(&unit->list);
> >      	write_unlock_irq(&port->unit_list_lock);
> >      	if (!unit)
> >      		return -EINVAL;
> >      	sdev = zfcp_unit_sdev(unit);
> >      	if (sdev) {
> >      		scsi_remove_device(sdev);
> >      		scsi_device_put(sdev);
> >      	}
> > // unit->dev (R = 2)
> >      	put_device(&unit->dev);
> > // unit->dev (R = 1)
> >      	device_unregister(&unit->dev);
> > // unit->dev (R = 0)
> >      	return 0;
> >      }
> > 
> > If we now apply this patch, we'd end up with R = 1 after
> > `device_unregister()`, and the device would not be properly removed.
> > 
> > If you still think that's wrong, then you'll need to better explain why.
> > 
> Hi Banjamin and Cornelia,
> 
> Your replies make me reliaze that I've been holding a mistake understanding
> of put_device() as well as reference count.
> 
> Thanks for you two's patient explanation !!
> 
> BTW, should I send a v2 on these two patches to move the position of
> put_device()?

Feel free to do so.

I think having the `put_device()` call after `device_unregister()` in
both `zfcp_unit_remove()` and `zfcp_sysfs_port_remove_store()` is more
natural, because it ought to be the last time we touch the object in
both functions.


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
