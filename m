Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95182C63777
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B04520DD4
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UaGWq2Xh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgKZJnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 04:43:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727570AbgKZJnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Nov 2020 04:43:18 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ9Xtsi066621;
        Thu, 26 Nov 2020 04:43:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=2maMWUcv392p49VaNaQyk4UgFiTr7QtDftkPoQgnCvk=;
 b=UaGWq2Xh3bLTmEM20zSUYFACIrkDpLHNDLyCAtL12Bv/OBh5++vHPsLrussy/M+wN3B8
 b9pHYd72uaW6s5EB0VS7e0+FT7aLJ/n7mEwDvmj63RFStcDQUb0etmtF0e9iQuWprYNL
 pyHkvUT013gxe7BKCgHbC/sPIRNCFCn9eKWpfaDCKNvvML6RjkQpABjm7ZGXTrYBVoa3
 +YM/HV3D6KwZn8e7FLlokGXY80yFzCjl9yZpJO9KS3Hcat9Bsuyf/2mn086iPoWckfOd
 FxT0UEPpXznaPxD5vUU2M/E0dQu43qOZHQRU+S19593tirskybjQj9J2ujvrrEHytROm uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3522mrjh7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 04:43:06 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AQ9bKeI081438;
        Thu, 26 Nov 2020 04:43:06 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3522mrjh5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 04:43:05 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ9SUYd019543;
        Thu, 26 Nov 2020 09:43:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 34y6k4tk8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 09:43:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ9h0OR4129284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 09:43:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCD9152054;
        Thu, 26 Nov 2020 09:43:00 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.178.201])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id A64AB52052;
        Thu, 26 Nov 2020 09:43:00 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kiDnn-002lfS-MN; Thu, 26 Nov 2020 10:42:59 +0100
Date:   Thu, 26 Nov 2020 10:42:59 +0100
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
Message-ID: <20201126094259.GE8578@t480-pf1aa2c2>
References: <20201120074854.31754-1-miaoqinglang@huawei.com>
 <20201125170658.GB8578@t480-pf1aa2c2>
 <4c65bead-2553-171e-54d2-87a9de0330e8@huawei.com>
 <20201126091353.50cf6ab6.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201126091353.50cf6ab6.cohuck@redhat.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_03:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260055
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2020 at 09:13:53AM +0100, Cornelia Huck wrote:
> On Thu, 26 Nov 2020 09:27:41 +0800
> Qinglang Miao <miaoqinglang@huawei.com> wrote:
> 
> > 在 2020/11/26 1:06, Benjamin Block 写道:
> > > On Fri, Nov 20, 2020 at 03:48:54PM +0800, Qinglang Miao wrote:  
> > >> kfree(port) is called in put_device(&port->dev) so that following
> > >> use would cause use-after-free bug.
> > >>
> > >> The former put_device is redundant for device_unregister contains
> > >> put_device already. So just remove it to fix this.
> > >>
> > >> Fixes: 86bdf218a717 ("[SCSI] zfcp: cleanup unit sysfs attribute usage")
> > >> Reported-by: Hulk Robot <hulkci@huawei.com>
> > >> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> > >> ---
> > >>   drivers/s390/scsi/zfcp_unit.c | 2 --
> > >>   1 file changed, 2 deletions(-)
> > >>
> > >> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
> > >> index e67bf7388..664b77853 100644
> > >> --- a/drivers/s390/scsi/zfcp_unit.c
> > >> +++ b/drivers/s390/scsi/zfcp_unit.c
> > >> @@ -255,8 +255,6 @@ int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
> > >>   		scsi_device_put(sdev);
> > >>   	}
> > >>   
> > >> -	put_device(&unit->dev);
> > >> -
> > >>   	device_unregister(&unit->dev);  
> > >>  >>   	return 0;  
> > > 
> > > Same as in the other mail for `zfcp_sysfs_port_remove_store()`. We
> > > explicitly get a new ref in `_zfcp_unit_find()`, so we also need to put
> > > that away again.
> > >  
> > Sorry, Benjamin, I don't think so, because device_unregister calls 
> > put_device inside.
> > 
> > It seem's that another put_device before or after device_unregister is 
> > useless and even might cause an use-after-free.
> 
> The issue here (and in the other patches that I had commented on) is
> that the references have different origins. device_register() acquires
> a reference, and that reference is given up when you call
> device_unregister(). However, the code here grabs an extra reference,
> and it of course has to give it up again when it no longer needs it.
> 
> This is something that is not that easy to spot by an automated check,
> I guess?
> 

Indeed.

I do think the two patches for zfcp have merit, but not by simply
removing the put_device(), but by moving it.

For this patch in particular, I'd think the "proper logic" would be to
move the `put_device()` to after the `device_unregister()`:

    device_unregister(&unit->dev);
    put_device(&unit->dev);

    return 0;

As Cornelia pointed out, the extra `get_device()` we do in
`_zfcp_unit_find()` needs to be reversed, otherwise we have a dangling
reference and probably some sort of memory-/resource-leak.

Let's go by example. If we assume the reference count of `unit->dev` is
R, and the function starts with R = 1 (otherwise the deivce would've
been freed already), we get:

    int zfcp_unit_remove(struct zfcp_port *port, u64 fcp_lun)
    {
    	struct zfcp_unit *unit;
    	struct scsi_device *sdev;
    
    	write_lock_irq(&port->unit_list_lock);
// unit->dev (R = 1)
    	unit = _zfcp_unit_find(port, fcp_lun);
// get_device(&unit->dev)
// unit->dev (R = 2)
    	if (unit)
    		list_del(&unit->list);
    	write_unlock_irq(&port->unit_list_lock);
    
    	if (!unit)
    		return -EINVAL;
    
    	sdev = zfcp_unit_sdev(unit);
    	if (sdev) {
    		scsi_remove_device(sdev);
    		scsi_device_put(sdev);
    	}
    
// unit->dev (R = 2)
    	put_device(&unit->dev);
// unit->dev (R = 1)
    	device_unregister(&unit->dev);
// unit->dev (R = 0)
    
    	return 0;
    }

If we now apply this patch, we'd end up with R = 1 after
`device_unregister()`, and the device would not be properly removed.

If you still think that's wrong, then you'll need to better explain why.


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
