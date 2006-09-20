From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] mptspi : min_period, max_offset,
	max_width,incorrectlyset, resulting domain validation failing
Date: Tue, 19 Sep 2006 21:16:37 -0400
Message-ID: <1158714997.4170.63.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7032CE62@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33154 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750775AbWITBQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 21:16:43 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7032CE62@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-09-19 at 17:06 -0600, Moore, Eric wrote:
> Also, the algorithm in spi_transport is broke for U160 devices. Its
> sending U320
> nego to U160 devices.  What it should do is check for
> scsi_device_ius(sdev) == 0
> and scsi_device_qas(sdev) == 0, then spi_min_period(sdev)=0x9.  Due to
> this,
> spi transport dv ends up with FAST-40, instead of U160, becuase the nego
> at factor=0x8 failed.

Well, by standard, I'm supposed to start out negotiation with the
fastest I can possibly do and the drive modifies this in its reply.  The
heuristics over DT vs non-DT in the transport class are to cope with
arguably buggy drives in the field.  I've never come across a DT capable
drive on an LVD bus that showed a problem in this regard ... have you
found one?

James


