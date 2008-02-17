From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi_debug: disable clustering
Date: Sun, 17 Feb 2008 07:28:48 -0700
Message-ID: <20080217142848.GD21012@parisc-linux.org>
References: <20080216235714H.tomof@acm.org> <20080217141045.GB21012@parisc-linux.org> <1203257892.3082.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36021 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbYBQO2t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Feb 2008 09:28:49 -0500
Content-Disposition: inline
In-Reply-To: <1203257892.3082.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <tomof@acm.org>, dougg@torque.net, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, Feb 17, 2008 at 08:18:11AM -0600, James Bottomley wrote:
> No, he means that kmap_atomic can only map a page of data.  This makes
> single page only sg list entries and input assumption into this loop.
> with ENABLE_CLUSTERING, that's potentially not true.   Of course, this
> accidentally works most of the time because of the way kmap functions.

Ah, right.  I'm on the verge of releasing a ram-based scsi driver I've
been working on ... this loop should work fine with clustering as it
takes account of the sg potentially having multiple pages:

        scsi_for_each_sg(cmnd, sg, scsi_sg_count(cmnd), i) {
                struct page *sgpage = sg_page(sg);
                unsigned int to_off = sg->offset;
                unsigned int sg_copy = sg->length;
                if (sg_copy > len)
                        sg_copy = len;
                len -= sg_copy;

                while (sg_copy > 0) {
                        char *vto, *vfrom;
                        unsigned int page_copy;

                        if (from_off > to_off)
                                page_copy = PAGE_SIZE - from_off;
                        else
                                page_copy = PAGE_SIZE - to_off;
                        if (page_copy > sg_copy)
                                page_copy = sg_copy;

                        vfrom = get_data_page(data_pfn);
                        vto = get_sg_page(sgpage);
                        memcpy(vto + to_off, vfrom + from_off, page_copy);
                        put_sg_page(vto);
                        put_data_page(vfrom);

                        from_off += page_copy;
                        if (from_off == PAGE_SIZE) {
                                from_off = 0;
                                data_pfn++;
                        }
                        to_off += page_copy;
                        if (to_off == PAGE_SIZE) {
                                to_off = 0;
                                sgpage++;
                        }
                        sg_copy -= page_copy;
                }
                if (!len)
                        break;
        }

get_data_page() and get_sg_page() each do a kmap_atomic, so I was
concerned that I might be out of KM_USER* pages.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
