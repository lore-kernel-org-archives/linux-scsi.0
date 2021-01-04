Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA46C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E421B2226A
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbhADTEC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 14:04:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54894 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADTEC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 14:04:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104Iii5I048337;
        Mon, 4 Jan 2021 19:03:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=Dj8qlp11GBVoQ/PXDNUMvZRUWJhzb98drblxMpLf7d8=;
 b=YlvrJ9pvv8jqYS7xnScPI+4Io2iDAPTPtBLFPxTsKNDXcJ5TJ8hX52NRUv9sSwHADDz3
 ML1uG/AUUJKpU4aYUJY5JdKQnibeD+giW2PR4Yy7wEfjIEAaZvC5ZQAf5kyXn2BIJdCM
 7Y/D+RCTZjoDwwnQ/+lXDZzyFaV9O5xwX5np0dqH5XtuP59LcGjvFF+b+TLcu3ZzYLrS
 sTeuSPw4pfUNJYIJdnjN2VvyA/1iNRj8sticLigZnzxbBOCOU7teU6AlZuvMRmRqnteV
 XEGqP6YXJ0eS1oqeCOUx4KGeOfpWT4V/IyEduD14NWrJLnhXHcWjTXPJ7PAf04MpwT07 Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35tebanu3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 04 Jan 2021 19:03:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 104IkLJE024624;
        Mon, 4 Jan 2021 19:03:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35v4rah92q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jan 2021 19:03:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104J2u4u021597;
        Mon, 4 Jan 2021 19:02:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 11:02:56 -0800
Date:   Mon, 4 Jan 2021 11:02:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "selvajove@gmail.com" <selvajove@gmail.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        "hch@lst.de" <hch@lst.de>,
        "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v4 2/3] block: add simple copy support
Message-ID: <20210104190254.GB6919@magnolia>
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
 <CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
 <20210104104159.74236-3-selvakuma.s1@samsung.com>
 <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SelvaKumar S: This didn't show up on dm-devel, sorry for the OT reply...

On Mon, Jan 04, 2021 at 12:47:11PM +0000, Damien Le Moal wrote:
> On 2021/01/04 19:48, SelvaKumar S wrote:
> > Add new BLKCOPY ioctl that offloads copying of one or more sources
> > ranges to a destination in the device. Accepts copy_ranges that contains
> > destination, no of sources and pointer to the array of source
> > ranges. Each range_entry contains start and length of source
> > ranges (in bytes).
> > 
> > Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> > bio with control information as payload and submit to the device.
> > REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted
> > to zoned device.
> > 
> > If the device doesn't support copy or copy offload is disabled, then
> > copy is emulated by allocating memory of total copy size. The source
> > ranges are read into memory by chaining bio for each source ranges and
> > submitting them async and the last bio waits for completion. After data
> > is read, it is written to the destination.
> > 
> > bio_map_kern() is used to allocate bio and add pages of copy buffer to
> > bio. As bio->bi_private and bio->bi_end_io is needed for chaining the
> > bio and over written, invalidate_kernel_vmap_range() for read is called
> > in the caller.
> > 
> > Introduce queue limits for simple copy and other helper functions.
> > Add device limits as sysfs entries.
> > 	- copy_offload
> > 	- max_copy_sectors
> > 	- max_copy_ranges_sectors
> > 	- max_copy_nr_ranges
> > 
> > copy_offload(= 0) is disabled by default.
> > max_copy_sectors = 0 indicates the device doesn't support native copy.
> > 
> > Native copy offload is not supported for stacked devices and is done via
> > copy emulation.
> > 
> > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > Signed-off-by: Javier González <javier.gonz@samsung.com>
> > ---
> >  block/blk-core.c          |  94 ++++++++++++++--
> >  block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++
> >  block/blk-merge.c         |   2 +
> >  block/blk-settings.c      |  10 ++
> >  block/blk-sysfs.c         |  50 +++++++++
> >  block/blk-zoned.c         |   1 +
> >  block/bounce.c            |   1 +
> >  block/ioctl.c             |  43 ++++++++
> >  include/linux/bio.h       |   1 +
> >  include/linux/blk_types.h |  15 +++
> >  include/linux/blkdev.h    |  13 +++
> >  include/uapi/linux/fs.h   |  13 +++

This series should also be cc'd to linux-api since you're adding a new
userspace api.

Alternately, save yourself the trouble of passing userspace API review
by hooking this up to the existing copy_file_range call in the vfs.  /me
hopes you sent blktests to check the operation of this thing, since none
of the original patches made it to this list.

If you really /do/ need a new kernel call for this, then please send in
a manpage documenting the fields of struct range_entry and copy_range,
and how users are supposed to use this.

<now jumping to the ioctl definition because Damien already reviewed the
plumbing...>

> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index f44eb0a04afd..5cadb176317a 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -64,6 +64,18 @@ struct fstrim_range {
> >  	__u64 minlen;
> >  };
> >  
> > +struct range_entry {
> > +	__u64 src;

Is this an offset?  Or the fd of an open bdev?

> > +	__u64 len;
> > +};
> > +
> > +struct copy_range {
> > +	__u64 dest;
> > +	__u64 nr_range;
> > +	__u64 range_list;

Hm, I think this is a pointer?  Why not just put the range_entry array
at the end of struct copy_range?

> > +	__u64 rsvd;

Also needs a flags argument so we don't have to add BLKCOPY2 in like 3
months.

--D

> > +};
> > +
> >  /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
> >  #define FILE_DEDUPE_RANGE_SAME		0
> >  #define FILE_DEDUPE_RANGE_DIFFERS	1
> > @@ -184,6 +196,7 @@ struct fsxattr {
> >  #define BLKSECDISCARD _IO(0x12,125)
> >  #define BLKROTATIONAL _IO(0x12,126)
> >  #define BLKZEROOUT _IO(0x12,127)
> > +#define BLKCOPY _IOWR(0x12, 128, struct copy_range)
> >  /*
> >   * A jump here: 130-131 are reserved for zoned block devices
> >   * (see uapi/linux/blkzoned.h)
> > 
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
