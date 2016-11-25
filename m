From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Fri, 25 Nov 2016 12:53:17 +0100
Message-ID: <20161125115317.llxd2lslf7ovitxd@linux-x5ow.site>
References: <1479738275.19792.24.camel@localhost.localdomain>
 <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
 <1479752642.19792.43.camel@localhost.localdomain>
 <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
 <1479839407.28416.21.camel@localhost.localdomain>
 <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
 <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com>
 <1479932524.28416.43.camel@localhost.localdomain>
 <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site>
 <CAPrnrPBcvBcNaZ5asJquRSp4Ann3xHVGSRbwLkvPF+YKJ6OpCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbcKYLxU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:53:20 -0500
Content-Disposition: inline
In-Reply-To: <CAPrnrPBcvBcNaZ5asJquRSp4Ann3xHVGSRbwLkvPF+YKJ6OpCw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eyal Ben David <bdeyal@gmail.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Laurence Oberman <loberman@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Fri, Nov 25, 2016 at 01:20:34PM +0200, Eyal Ben David wrote:
> Note that sg_mmap_read does not parse the SCSI sense, so the script
> might fail for other reasons (some SCSI error) and think its a zero
> byte corruption.

But SCSI generic checks for errors and returns -EINVAL on CHECK_CONDITION or
DRIVER_SENSE (and sets SG_INFO_CHECK in hdr.info).

And:
VM:~ # ./test.sh 
FAIL on run 2
Expect:
0000000 8240 3d1f 8800 ffff 0002 0000 0000 0000
0000020 0000 0000 0000 0000 6e9d 57ac 0000 0000
0000040 0000 0000 0000 0000 0000 0000 0000 0000
*
0000100
Fail:
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0000100
VM:~ # uname -r
4.8.9-60-default+
VM:~ # 


Anyways, can you test the patch Ewan found on one of your kernel's that are
known to fail?

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
