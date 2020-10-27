Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278CAC4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 05:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB53321707
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 05:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qBPEnsWr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506100AbgJ0Frm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 01:47:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506028AbgJ0Frm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 01:47:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5dgST182745;
        Tue, 27 Oct 2020 05:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LuEBVYF3yylX0ZWV4kw8E4V/gRYjWhuzn0NP3CPTr9c=;
 b=qBPEnsWrdaahRbGyIbowq4ppKunqkhEOkIVx2QKz0QwxuYZrU1yHzIt90iL5jK2RSKnb
 3IIB1ymWj+OygjLPvU1AzGQoHQsHpZWuKwSEFLHLNzWOIZPzs/kGp+lk1ZEdNZOWytdp
 1zNqcWECy1YeNzCF4jOtuXgHqGoBsMlhiiUDPgWMf+Q5LtfsbFKGu9WNMqr6vWUef/+n
 GB4B+/Kxh6YgswVLBMWCJH8jT5UAszkVT5gPbhpr5Hk50krSGn2twLfXzaalCgqJrH8d
 oQQWVwJYeoCH7cyFBEErha/oU90KMaEoiOHOSB3B1xcGRWDIwmdct5P2LHzVUM2LLx9x 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kqxku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 05:47:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5eO5w013321;
        Tue, 27 Oct 2020 05:47:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwum00fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 05:47:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09R5lZDq023623;
        Tue, 27 Oct 2020 05:47:35 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 22:47:35 -0700
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
To:     Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
Date:   Tue, 27 Oct 2020 00:47:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270038
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/20 10:51 PM, Jason Wang wrote:
> 
> On 2020/10/22 上午8:34, Mike Christie wrote:
>> Each vhost-scsi device will need a evt and ctl queue, but the number
>> of IO queues depends on whatever the user has configured in userspace.
>> This patch has vhost-scsi create the evt, ctl and one IO vq at device
>> open time. We then create the other IO vqs when userspace starts to
>> set them up. We still waste some mem on the vq and scsi vq structs,
>> but we don't waste mem on iovec related arrays and for later patches
>> we know which queues are used by the dev->nvqs value.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/vhost/scsi.c | 19 +++++++++++++++----
>>   1 file changed, 15 insertions(+), 4 deletions(-)
> 
> 
> Not familiar with SCSI. But I wonder if it could behave like vhost-net.
> 
> E.g userspace should known the number of virtqueues so it can just open 
> and close multiple vhost-scsi file descriptors.
> 

One hiccup I'm hitting is that we might end up creating about 3x more 
vqs than we need. The problem is that for scsi each vhost device has:

vq=0: special control vq
vq=1: event vq
vq=2 and above: SCSI CMD/IO vqs. We want to create N of these.

Today we do:

Uerspace does open(/dev/vhost-scsi)
         vhost_dev_init(create 128 vqs and then later we setup and use N 
of them);

Qemu does ioctl(VHOST_SET_OWNER)
         vhost_dev_set_owner()

For N vqs userspace does:
         // virtqueue setup related ioctls

Qemu does ioctl(VHOST_SCSI_SET_ENDPOINT)
         - match LIO/target port to vhost_dev


So we could change that to:

For N IO vqs userspace does
         open(/dev/vhost-scsi)
                 vhost_dev_init(create IO, evt, and ctl);

for N IO vqs Qemu does:
         ioctl(VHOST_SET_OWNER)
                 vhost_dev_set_owner()

for N IO vqs Qemu does:
         // virtqueue setup related ioctls

for N IO vqs Qemu does:
         ioctl(VHOST_SCSI_SET_ENDPOINT)
                 - match LIO/target port to vhost_dev and assemble the 
multiple vhost_dev device.

The problem is that we have to setup some of the evt/ctl specific parts 
at open() time when vhost_dev_init does vhost_poll_init for example.

- At open time, we don't know if this vhost_dev is going to be part of a 
multiple vhost_device device or a single one so we need to create at 
least 3 of them
- If it is a multiple device we don't know if its the first device being 
created for the device or the N'th, so we don't know if the dev's vqs 
will be used for IO or ctls/evts, so we have to create all 3.

When we get the first VHOST_SCSI_SET_ENDPOINT call for a new style 
multiple vhost_dev device, we can use that dev's evt/ctl vqs for 
events/controls requests. When we get the other VHOST_SCSI_SET_ENDPOINT 
calls for the multiple vhost_dev device then those dev's evt/ctl vqs 
will be ignored and we will only use their IO vqs. So we end up with a 
lot of extra vqs.


One other question/issue I have is that qemu can open the 
/dev/vhost-scsi device or it allows tools like libvirtd to open the 
device and pass in the fd to use. For the latter case, would we continue 
to have those tools pass in the leading fd, then have qemu do the other 
num_queues - 1 open(/dev/vhost-scsi) calls? Or do these apps that pass 
in the fd need to know about all of the fds for some management reason?

