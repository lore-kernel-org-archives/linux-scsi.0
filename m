Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E34C55179
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 16:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 594902192A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 16:21:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mBY+D8BQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750410AbgJWQVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 12:21:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750399AbgJWQVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2020 12:21:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NG8oxF134604;
        Fri, 23 Oct 2020 16:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=l58/qWGu40QiUC+C5KNGwg2Ew/BBVH99oeQCuZUlCiY=;
 b=mBY+D8BQZ8rED7XAvlz9mLYZlkdPcOPx+qVgk9zL+Q8/EROmHKzQEZh0nv+Mha2nFJsM
 SiydpDaNts3MRk7HLKV9eE9lUZr2dynnk8eZ3nNl8L2iexfgb8UPqWqMRnZTRvZ4lmZu
 ZSyhZsNBN53J7waDZCgPVg0tf4pY9NdkvQNEsykKiEpAWEUtSdJf9KxUsNxDZv29pBKl
 NEL2GncuyJAmsmQ7oBkCf+7k2ZrdgXeo0rmAb4AAO2bliKW3Vr07qlYIxYc6WLIMr6CP
 QKrXk4QrVA5YIyT1l3Pf+RxJaUMjGlexXAj4Ncxf4NeIy0i70Qmbph3VqR6/4EgaHbYY lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 349jrq43xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 16:21:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NGB5RL035328;
        Fri, 23 Oct 2020 16:21:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348aj14ypg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 16:21:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09NGLK4M004607;
        Fri, 23 Oct 2020 16:21:20 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Oct 2020 09:21:19 -0700
Subject: Re: [PATCH 04/16] vhost: prep vhost_dev_init users to handle failures
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org, lkp@intel.com,
        kbuild-all@lists.01.org
References: <1602104101-5592-5-git-send-email-michael.christie@oracle.com>
 <20201009114126.GI1042@kadam> <20201023115635-mutt-send-email-mst@kernel.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <3361538b-15bf-fb92-040b-fd9c33370c70@oracle.com>
Date:   Fri, 23 Oct 2020 11:21:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201023115635-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/20 10:56 AM, Michael S. Tsirkin wrote:
> On Fri, Oct 09, 2020 at 02:41:26PM +0300, Dan Carpenter wrote:
>> Hi Mike,
>>
>> url:    https://urldefense.com/v3/__https://github.com/0day-ci/linux/commits/Mike-Christie/vhost-fix-scsi-cmd-handling-and-IOPs/20201008-045802__;!!GqivPVa7Brio!PSUeg8MO8B2TLNpewKuGd0oWY8N3pkO7w9hbCh3xgWK3TgFsPr78zcIUZ8Orgxgaqydf$
>> base:   https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git__;!!GqivPVa7Brio!PSUeg8MO8B2TLNpewKuGd0oWY8N3pkO7w9hbCh3xgWK3TgFsPr78zcIUZ8Org7WbKd27$  linux-next
>> config: x86_64-randconfig-m001-20201008 (attached as .config)
>> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> New smatch warnings:
>> drivers/vhost/vdpa.c:844 vhost_vdpa_open() error: uninitialized symbol 'r'.
>>
>> Old smatch warnings:
>> drivers/vhost/vdpa.c:436 vhost_vdpa_unlocked_ioctl() warn: maybe return -EFAULT instead of the bytes remaining?
>> drivers/vhost/vdpa.c:489 vhost_vdpa_unlocked_ioctl() warn: maybe return -EFAULT instead of the bytes remaining?
>>
>> vim +/r +844 drivers/vhost/vdpa.c
>>
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  793  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  794  {
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  795  	struct vhost_vdpa *v;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  796  	struct vhost_dev *dev;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  797  	struct vhost_virtqueue **vqs;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  798  	int nvqs, i, r, opened;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  799
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  800  	v = container_of(inode->i_cdev, struct vhost_vdpa, cdev);
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  801
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  802  	opened = atomic_cmpxchg(&v->opened, 0, 1);
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  803  	if (opened)
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  804  		return -EBUSY;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  805
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  806  	nvqs = v->nvqs;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  807  	vhost_vdpa_reset(v);
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  808
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  809  	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  810  	if (!vqs) {
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  811  		r = -ENOMEM;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  812  		goto err;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  813  	}
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  814
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  815  	dev = &v->vdev;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  816  	for (i = 0; i < nvqs; i++) {
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  817  		vqs[i] = &v->vqs[i];
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  818  		vqs[i]->handle_kick = handle_vq_kick;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  819  	}
>> 7dc4d1082d406f3 Mike Christie 2020-10-07  820  	if (vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>> 7dc4d1082d406f3 Mike Christie 2020-10-07  821  			   vhost_vdpa_process_iotlb_msg))
>> 7dc4d1082d406f3 Mike Christie 2020-10-07  822  		goto err_dev_init;
>>
>> "r" not set on this error path.
>>
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  823
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  824  	dev->iotlb = vhost_iotlb_alloc(0, 0);
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  825  	if (!dev->iotlb) {
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  826  		r = -ENOMEM;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  827  		goto err_init_iotlb;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  828  	}
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  829
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  830  	r = vhost_vdpa_alloc_domain(v);
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  831  	if (r)
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  832  		goto err_init_iotlb;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  833
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  834  	filep->private_data = v;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  835
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  836  	return 0;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  837
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  838  err_init_iotlb:
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  839  	vhost_dev_cleanup(&v->vdev);
>> 7dc4d1082d406f3 Mike Christie 2020-10-07  840  err_dev_init:
>> 37787e9f81e2e58 Mike Christie 2020-09-21  841  	kfree(vqs);
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  842  err:
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  843  	atomic_dec(&v->opened);
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26 @844  	return r;
>> 4c8cf31885f69e8 Tiwei Bie     2020-03-26  845  }
> 
> 
> Yes looks like it would use r uninitialized ...
> Mike?
> 

Ah sorry, I had posted a v3 of this patchset:

https://patchwork.kernel.org/project/target-devel/list/?series=368487

and I fixed that but there was another cases of uninitialized variable 
that I missed. I fixed that up now, but have not posted an updated set.
