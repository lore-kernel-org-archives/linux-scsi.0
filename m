From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: 14 Oct 2004 13:05:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097777109.2198.31.camel@mulgrave>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
	<20041013214629.GA30273@osdl.org> <1097704592.1714.266.camel@mulgrave>
	<20041014175218.GA31885@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59819 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267165AbUJNSF7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 14:05:59 -0400
In-Reply-To: <20041014175218.GA31885@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Dave Olien' <dmo@osdl.org>
Cc: "Qi, Yanling" <yanling.qi@engenio.com>, Douglas Gilbert <dougg@torque.net>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-10-14 at 12:52, 'Dave Olien' wrote:
> comp cmd cfa9d8a0 good_bytes 0 nr_phys_req 5 use_sg 10
> Incorrect number of segments after building list cmd cfa9d8a0
> counted 10, received 5
> req nr_sec 1024, cur_nr_sec 8
> Buffer I/O error on device sda, logical block 5489

Well, I managed to create a test rig that randomly rejects commands with
UNIT ATTENTION (and QUEUE FULL just for good measure).  So far I've seen
this condition once so it looks like you have the better ability to
reproduce.

What happens is that nr_phys_segments is being reduced *after* the
sgtable is allocated the first time (otherwise there would be an
Incorrect segments message for its initial mapping).  Why this is
happening, I still can't fathom.

James


