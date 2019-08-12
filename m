Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B464C433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 18:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E195620684
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 18:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfHLSqa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 14:46:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbfHLSqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 14:46:30 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CIcMe7107803;
        Mon, 12 Aug 2019 14:46:07 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ubcdjtvmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 14:46:07 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7CIYnDD027428;
        Mon, 12 Aug 2019 18:46:06 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 2u9nj6rrmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 18:46:06 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CIk5OG51052910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 18:46:05 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77BBC112064;
        Mon, 12 Aug 2019 18:46:05 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C2AD112061;
        Mon, 12 Aug 2019 18:46:04 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.80.199.198])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 18:46:04 +0000 (GMT)
Message-ID: <1565635563.3287.1.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 17/20] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
From:   James Bottomley <jejb@linux.vnet.ibm.com>
To:     Tony Battersby <tonyb@cybernetics.com>, dgilbert@interlog.com,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org,
        kbuild test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 12 Aug 2019 11:46:03 -0700
In-Reply-To: <500183f3-fb16-77b7-90e0-5c8bb2a021c3@cybernetics.com>
References: <20190807114252.2565-1-dgilbert@interlog.com>
         <20190807114252.2565-18-dgilbert@interlog.com>
         <1565392510.17449.18.camel@linux.vnet.ibm.com>
         <048b4ab4-804b-f6ec-c35a-47cd2f8d8cda@interlog.com>
         <500183f3-fb16-77b7-90e0-5c8bb2a021c3@cybernetics.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120196
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-08-12 at 12:14 -0400, Tony Battersby wrote:
> On 8/12/19 11:37 AM, Douglas Gilbert wrote:
> > On 2019-08-09 7:15 p.m., James Bottomley wrote:
> > > On Wed, 2019-08-07 at 13:42 +0200, Douglas Gilbert wrote:
> > > > Add ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3). These
> > > > ioctls
> > > > are meant to be (almost) drop-in replacements for the
> > > > write()/read()
> > > > async version 3 interface. They only accept the version 3
> > > > interface.
> > > 
> > > I don't think we should do this at all.  Anyone who wants to use
> > > the
> > > new async interfaces should use the v4 headers.  As Tony
> > > Battersby
> > > already said, the legacy v3 users aren't going to update, so
> > > there's no
> > > point at all introducing new interfaces for v3.  We simply keep
> > > the v3
> > > only read/write interface until there are no users left and it
> > > can be
> > > eliminated.
> > 
> > Tony Battersby wrote [20190809]:
> >    "Actually I used the asynchronous write()/read()/poll() sg
> > interface to
> >    implement RAID-like functionality for tape drives and medium
> > changers,
> >    in a commercial product that has been around since 2002.  These
> > days our
> >    products use a lot more disk I/O than tape I/O, so I don't write
> > much
> >    new code using the sg interface anymore, although that code is
> > still
> >    there and has to be maintained as needed.  So I don't have any
> > immediate
> >    plans to use any of the new sgv4 features being introduced, and
> >    unfortunately I am way too busy to even give it a good
> > review..."
> > 
> > That is quoted in full his post. And here is the only other post
> > from
> > Tony I can find on this subject, again quoted in full [20190808]:
> > 
> >    "One of the reasons ioctls have a bad reputation is because they
> > can be
> >    used to implement poorly-thought-out interfaces.  So kernel
> > maintainers
> >    push back on adding new ioctls.  But the push back isn't about
> > the
> >    number of ioctls, it is about the poor interfaces.  My advice
> > was that
> >    in general, to implement a given API, it would be better to add
> > more
> >    ioctls with a simple interface for each one rather than to add
> > fewer
> >    extremely complex multiplexing ioctls."
> > 
> > Call me biased but I believe that taken together those posts
> > support
> > what I am proposing. And I can _not_ see how you deduce: "so
> > there's
> > no point at all introducing new interfaces for v3" in reference to
> > Tony's posts.
> > 
> > 
> > As I stated in a previous post, I do not consider the sg v3
> > interface
> > as legacy. Where simply implemented, I am prepared to implement new
> > features on both the sg v3 and v4 interfaces. One example of this
> > is
> > doing command timing in nanoseconds rather than the current
> > default,
> > which is timing in milliseconds. There is also the new option of
> > not
> > doing any command timing at all. In my current implementation it
> > would
> > actually be more code to implement that for the v4 interface but
> > not
> > for the v3 interface.
> > 
> > Replicating my argument from a previous post:
> > If the kernel had an API mapping layer that was sensitive to file
> > descriptors of a "special file" (e.g. "/dev/sg3") then it could
> > map:
> >      write(sg_fd, &sg_io_v3_obj, sizeof(sg_io_v3_obj))
> > to
> >      ioctl(sg_fd, SG_IOSUBMIT_V3, &sg_io_v3_obj)
> > 
> > Plus a similar mapping for read() to ioctl(SG_IORECEIVE_V3). If
> > such
> > a mapping did exist and was transparent to the user then write()
> > and read() could be retired from the sg driver.  And I assume that
> > would get a thumbs up from the kernel security folk.
> > 
> 
> FWIW, my employer will probably continue to use the async sg v3
> interface for a long time.  If the read/write syscalls are a security
> problem, and if we had ioctl()s that are mostly a drop-in replacement
> for them, then we could convert our products over to the new ioctl()s
> on our next kernel upgrade without too much work (our products are
> embedded devices, so we control the whole software stack).  So if you
> plan to deprecate the read/write syscall interface anytime soon, then
> having drop-in replacement ioctl()s would be beneficial, even if it
> can't be done transparently as Doug suggests.

So far we've mitigated the security threat by withdrawing the v4
r/w interface which you don't use and keeping the sg nodes root only
for v3 r/w.  Unless we get another security incident based on them, as
long as the use case doesn't expand, I think the prior issue is pretty
nasty but contained to root who should know what they're doing, so
there's no pressing need to remove it.

Given that shifting to ioctls or a different async interface would be
development anyway, is there a solid reason you couldn't also shift to
v4 if you do that?  I know all the field names changed but for a
standard SCSI command it should be very similar to v3.

James

