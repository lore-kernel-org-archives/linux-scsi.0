From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: 14 Oct 2004 15:39:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097786376.2198.43.camel@mulgrave>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
	<20041013214629.GA30273@osdl.org> <1097704592.1714.266.camel@mulgrave>
	<20041014175218.GA31885@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42157 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267330AbUJNUkb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 16:40:31 -0400
In-Reply-To: <20041014175218.GA31885@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Dave Olien' <dmo@osdl.org>, Jens Axboe <axboe@suse.de>
Cc: "Qi, Yanling" <yanling.qi@engenio.com>, Douglas Gilbert <dougg@torque.net>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

OK, I caught it with actual data this time

If you analyse my trace you see that blk_rq_map_sg() is insisting on a
phys segment size of no more than 65536 bytes (which gives it 11
segments since some are bigger than this).  However, an exact count of
the number of phys segments without this boundary would yield 5, which
is exactly the figure we get.

I theorise that the initial request had nr_phys_segments pretty high, so
it mapped OK.  Then later we trigger a recount somehow using
blk_recalc_rq_segments() which drops it to 5

Therefore it seems to me that the problem occurs because
blk_recalc_rq_segment size is failing to respect the queueu
max_segment_size (which is set to 65536 by default).

James

REQUEUE: doing a reinsertion of request c37dc270, use_sg=11, nr_phys_segments=5, nr_hw_segments=128

 FOUND FAILING CASE
after recalc_rq_segments nr_phys_segments=5, nr_hw_segments=128

SG SEGMENTS FROM cmd ARE:
0: 0x008e7000-0x008f7000 [65536]
1: 0x008f7000-0x00903000 [49152]
2: 0x00904000-0x00914000 [65536]
3: 0x00914000-0x00919000 [20480]
4: 0x0091a000-0x0091e000 [16384]
5: 0x0091f000-0x0092f000 [65536]
6: 0x0092f000-0x0093f000 [65536]
7: 0x0093f000-0x0094f000 [65536]
8: 0x0094f000-0x00958000 [36864]
9: 0x00959000-0x00969000 [65536]
10: 0x00969000-0x0096b000 [8192]

bio0, seg0: 0x008e7000-0x008e8000 [4096]
bio1, seg0: 0x008e8000-0x008e9000 [4096]
bio2, seg0: 0x008e9000-0x008ea000 [4096]
bio3, seg0: 0x008ea000-0x008eb000 [4096]
bio4, seg0: 0x008eb000-0x008ec000 [4096]
bio5, seg0: 0x008ec000-0x008ed000 [4096]
bio6, seg0: 0x008ed000-0x008ee000 [4096]
bio7, seg0: 0x008ee000-0x008ef000 [4096]
bio8, seg0: 0x008ef000-0x008f0000 [4096]
bio9, seg0: 0x008f0000-0x008f1000 [4096]
bio10, seg0: 0x008f1000-0x008f2000 [4096]
bio11, seg0: 0x008f2000-0x008f3000 [4096]
bio12, seg0: 0x008f3000-0x008f4000 [4096]
bio13, seg0: 0x008f4000-0x008f5000 [4096]
bio14, seg0: 0x008f5000-0x008f6000 [4096]
bio15, seg0: 0x008f6000-0x008f7000 [4096]
bio16, seg0: 0x008f7000-0x008f8000 [4096]
bio17, seg0: 0x008f8000-0x008f9000 [4096]
bio18, seg0: 0x008f9000-0x008fa000 [4096]
bio19, seg0: 0x008fa000-0x008fb000 [4096]
bio20, seg0: 0x008fb000-0x008fc000 [4096]
bio21, seg0: 0x008fc000-0x008fd000 [4096]
bio22, seg0: 0x008fd000-0x008fe000 [4096]
bio23, seg0: 0x008fe000-0x008ff000 [4096]
bio24, seg0: 0x008ff000-0x00900000 [4096]
bio25, seg0: 0x00900000-0x00901000 [4096]
bio26, seg0: 0x00901000-0x00902000 [4096]
bio27, seg0: 0x00902000-0x00903000 [4096]
bio28, seg0: 0x00904000-0x00905000 [4096]
bio29, seg0: 0x00905000-0x00906000 [4096]
bio30, seg0: 0x00906000-0x00907000 [4096]
bio31, seg0: 0x00907000-0x00908000 [4096]
bio32, seg0: 0x00908000-0x00909000 [4096]
bio33, seg0: 0x00909000-0x0090a000 [4096]
bio34, seg0: 0x0090a000-0x0090b000 [4096]
bio35, seg0: 0x0090b000-0x0090c000 [4096]
bio36, seg0: 0x0090c000-0x0090d000 [4096]
bio37, seg0: 0x0090d000-0x0090e000 [4096]
bio38, seg0: 0x0090e000-0x0090f000 [4096]
bio39, seg0: 0x0090f000-0x00910000 [4096]
bio40, seg0: 0x00910000-0x00911000 [4096]
bio41, seg0: 0x00911000-0x00912000 [4096]
bio42, seg0: 0x00912000-0x00913000 [4096]
bio43, seg0: 0x00913000-0x00914000 [4096]
bio44, seg0: 0x00914000-0x00915000 [4096]
bio45, seg0: 0x00915000-0x00916000 [4096]
bio46, seg0: 0x00916000-0x00917000 [4096]
bio47, seg0: 0x00917000-0x00918000 [4096]
bio48, seg0: 0x00918000-0x00919000 [4096]
bio49, seg0: 0x0091a000-0x0091b000 [4096]
bio50, seg0: 0x0091b000-0x0091c000 [4096]
bio51, seg0: 0x0091c000-0x0091d000 [4096]
bio52, seg0: 0x0091d000-0x0091e000 [4096]
bio53, seg0: 0x0091f000-0x00920000 [4096]
bio54, seg0: 0x00920000-0x00921000 [4096]
bio55, seg0: 0x00921000-0x00922000 [4096]
bio56, seg0: 0x00922000-0x00923000 [4096]
bio57, seg0: 0x00923000-0x00924000 [4096]
bio58, seg0: 0x00924000-0x00925000 [4096]
bio59, seg0: 0x00925000-0x00926000 [4096]
bio60, seg0: 0x00926000-0x00927000 [4096]
bio61, seg0: 0x00927000-0x00928000 [4096]
bio62, seg0: 0x00928000-0x00929000 [4096]
bio63, seg0: 0x00929000-0x0092a000 [4096]
bio64, seg0: 0x0092a000-0x0092b000 [4096]
bio65, seg0: 0x0092b000-0x0092c000 [4096]
bio66, seg0: 0x0092c000-0x0092d000 [4096]
bio67, seg0: 0x0092d000-0x0092e000 [4096]
bio68, seg0: 0x0092e000-0x0092f000 [4096]
bio69, seg0: 0x0092f000-0x00930000 [4096]
bio70, seg0: 0x00930000-0x00931000 [4096]
bio71, seg0: 0x00931000-0x00932000 [4096]
bio72, seg0: 0x00932000-0x00933000 [4096]
bio73, seg0: 0x00933000-0x00934000 [4096]
bio74, seg0: 0x00934000-0x00935000 [4096]
bio75, seg0: 0x00935000-0x00936000 [4096]
bio76, seg0: 0x00936000-0x00937000 [4096]
bio77, seg0: 0x00937000-0x00938000 [4096]
bio78, seg0: 0x00938000-0x00939000 [4096]
bio79, seg0: 0x00939000-0x0093a000 [4096]
bio80, seg0: 0x0093a000-0x0093b000 [4096]
bio81, seg0: 0x0093b000-0x0093c000 [4096]
bio82, seg0: 0x0093c000-0x0093d000 [4096]
bio83, seg0: 0x0093d000-0x0093e000 [4096]
bio84, seg0: 0x0093e000-0x0093f000 [4096]
bio85, seg0: 0x0093f000-0x00940000 [4096]
bio86, seg0: 0x00940000-0x00941000 [4096]
bio87, seg0: 0x00941000-0x00942000 [4096]
bio88, seg0: 0x00942000-0x00943000 [4096]
bio89, seg0: 0x00943000-0x00944000 [4096]
bio90, seg0: 0x00944000-0x00945000 [4096]
bio91, seg0: 0x00945000-0x00946000 [4096]
bio92, seg0: 0x00946000-0x00947000 [4096]
bio93, seg0: 0x00947000-0x00948000 [4096]
bio94, seg0: 0x00948000-0x00949000 [4096]
bio95, seg0: 0x00949000-0x0094a000 [4096]
bio96, seg0: 0x0094a000-0x0094b000 [4096]
bio97, seg0: 0x0094b000-0x0094c000 [4096]
bio98, seg0: 0x0094c000-0x0094d000 [4096]
bio99, seg0: 0x0094d000-0x0094e000 [4096]
bio100, seg0: 0x0094e000-0x0094f000 [4096]
bio101, seg0: 0x0094f000-0x00950000 [4096]
bio102, seg0: 0x00950000-0x00951000 [4096]
bio103, seg0: 0x00951000-0x00952000 [4096]
bio104, seg0: 0x00952000-0x00953000 [4096]
bio105, seg0: 0x00953000-0x00954000 [4096]
bio106, seg0: 0x00954000-0x00955000 [4096]
bio107, seg0: 0x00955000-0x00956000 [4096]
bio108, seg0: 0x00956000-0x00957000 [4096]
bio109, seg0: 0x00957000-0x00958000 [4096]
bio110, seg0: 0x00959000-0x0095a000 [4096]
bio111, seg0: 0x0095a000-0x0095b000 [4096]
bio112, seg0: 0x0095b000-0x0095c000 [4096]
bio113, seg0: 0x0095c000-0x0095d000 [4096]
bio114, seg0: 0x0095d000-0x0095e000 [4096]
bio115, seg0: 0x0095e000-0x0095f000 [4096]
bio116, seg0: 0x0095f000-0x00960000 [4096]
bio117, seg0: 0x00960000-0x00961000 [4096]
bio118, seg0: 0x00961000-0x00962000 [4096]
bio119, seg0: 0x00962000-0x00963000 [4096]
bio120, seg0: 0x00963000-0x00964000 [4096]
bio121, seg0: 0x00964000-0x00965000 [4096]
bio122, seg0: 0x00965000-0x00966000 [4096]
bio123, seg0: 0x00966000-0x00967000 [4096]
bio124, seg0: 0x00967000-0x00968000 [4096]
bio125, seg0: 0x00968000-0x00969000 [4096]
bio126, seg0: 0x00969000-0x0096a000 [4096]
bio127, seg0: 0x0096a000-0x0096b000 [4096]
Incorrect number of segments after building list
counted 11, received 5
req nr_sec 1024, cur_nr_sec 8
nr_hw_segments = 128
segments now 5
slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or memory outside object was overwritten

