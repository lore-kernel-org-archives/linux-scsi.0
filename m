From: "'Dave Olien'" <dmo@osdl.org>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Thu, 14 Oct 2004 10:52:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041014175218.GA31885@osdl.org>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com> <20041013214629.GA30273@osdl.org> <1097704592.1714.266.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:7367 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266888AbUJNRwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 13:52:32 -0400
Content-Disposition: inline
In-Reply-To: <1097704592.1714.266.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Qi, Yanling" <yanling.qi@engenio.com>, Douglas Gilbert <dougg@torque.net>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


James,

Sorry this took so long.  Here's I think the information you're asking for.
Just to make sure I'm not overlooking something...  I'm doing
IO on the /dev/sda, /dev/sdb, etc. devices.  I DO have multipath
software installed, and there ARE multipath dm devices present, but since
I'm doing IO only through the lower level devices, not the dm devices,
I've been assuming that the dm device is not in play here.

However, I want to point out, I get A LOT MORE of these types of
errors when I do IO through the multipath device.  I thought it made
sense though to track down the lower level error first.

If you think it could be an issue, I can go back and deconfigure
the dm device and try this again.

In the data below, the "comp cmd" strings are being printed out in
the scsi_io_completion() routine, as part of the unit attention
sense key parsing.  The first hex value is the address of the scsi_cmnd
structure.  The rest are pretty obvious.  I decided to print good_bytes
on the chance that these IO's maybe were partial completions.

The "Incorrect number of segments" string of course is the source of our
concern.  I added the address of the scsi_cmnd to the end of this string,
to make sure it corresponds to the same command that got the sense key.

comp cmd cfa9d8a0 good_bytes 0 nr_phys_req 5 use_sg 10
Incorrect number of segments after building list cmd cfa9d8a0
counted 10, received 5
req nr_sec 1024, cur_nr_sec 8
Buffer I/O error on device sda, logical block 5489
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5490
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5491
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5492
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5493
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5494
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5495
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5496
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5497
lost page write due to I/O error on sda
Buffer I/O error on device sda, logical block 5498
lost page write due to I/O error on sda
comp cmd cfa9d480 good_bytes 0 nr_phys_req 10 use_sg 12
Incorrect number of segments after building list cmd cfa9d480
counted 12, received 10
req nr_sec 1024, cur_nr_sec 8
comp cmd cfa9d8a0 good_bytes 0 nr_phys_req 80 use_sg 80
comp cmd cfa9da00 good_bytes 0 nr_phys_req 107 use_sg 107
comp cmd cfa9d060 good_bytes 0 nr_phys_req 105 use_sg 105
comp cmd c6181e80 good_bytes 0 nr_phys_req 114 use_sg 114
comp cmd cfda4b40 good_bytes 0 nr_phys_req 112 use_sg 112
comp cmd cfda45c0 good_bytes 0 nr_phys_req 108 use_sg 108
comp cmd cfda49e0 good_bytes 0 nr_phys_req 106 use_sg 106
comp cmd cfda4880 good_bytes 0 nr_phys_req 114 use_sg 114
comp cmd cfda4460 good_bytes 0 nr_phys_req 112 use_sg 112
comp cmd cfa9d5e0 good_bytes 0 nr_phys_req 116 use_sg 116
comp cmd cfa9db60 good_bytes 0 nr_phys_req 114 use_sg 114
comp cmd cfda4040 good_bytes 0 nr_phys_req 93 use_sg 93
comp cmd cfa9d1c0 good_bytes 0 nr_phys_req 97 use_sg 97
comp cmd cfa9dcc0 good_bytes 0 nr_phys_req 18 use_sg 22
Incorrect number of segments after building list cmd cfa9dcc0
counted 22, received 18
req nr_sec 1024, cur_nr_sec 8
comp cmd cfda4300 good_bytes 0 nr_phys_req 68 use_sg 69
Incorrect number of segments after building list cmd cfda4300
counted 69, received 68
req nr_sec 1024, cur_nr_sec 8
comp cmd cfa9d320 good_bytes 0 nr_phys_req 80 use_sg 80
comp cmd cfa9d8a0 good_bytes 0 nr_phys_req 80 use_sg 80
comp cmd cfa9da00 good_bytes 0 nr_phys_req 107 use_sg 107
comp cmd cfa9d060 good_bytes 0 nr_phys_req 105 use_sg 105
comp cmd c6181e80 good_bytes 0 nr_phys_req 114 use_sg 114
comp cmd cfda4b40 good_bytes 0 nr_phys_req 112 use_sg 112
comp cmd cfda45c0 good_bytes 0 nr_phys_req 108 use_sg 108
comp cmd cfda49e0 good_bytes 0 nr_phys_req 106 use_sg 106
comp cmd cfda4880 good_bytes 0 nr_phys_req 114 use_sg 114
comp cmd cfda4460 good_bytes 0 nr_phys_req 112 use_sg 112
comp cmd cfa9d5e0 good_bytes 0 nr_phys_req 116 use_sg 116
comp cmd cfa9db60 good_bytes 0 nr_phys_req 114 use_sg 114
comp cmd cfda4040 good_bytes 0 nr_phys_req 93 use_sg 93
comp cmd cfa9d1c0 good_bytes 0 nr_phys_req 97 use_sg 97
comp cmd cfa9d480 good_bytes 0 nr_phys_req 105 use_sg 105
comp cmd cdfbc300 good_bytes 0 nr_phys_req 19 use_sg 20
Incorrect number of segments after building list cmd cdfbc300
counted 20, received 19
req nr_sec 1024, cur_nr_sec 8


and so on... I have more if you like...

On Wed, Oct 13, 2004 at 04:56:25PM -0500, James Bottomley wrote:
> In the unit attention, could you print out cmd->use_sg and
> cmd->request->nr_phys_segments ... just to see what values got set up
> the first time around, which might give a clue where to look for the
> problem.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
