From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] improvement of fastfail operation
Date: Tue, 30 Mar 2004 21:14:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0403302108550.7851-200000@dyn319701.beaverton.ibm.com>
References: <1080696593.2075.120.camel@mulgrave>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="789163286-913007327-1080710077=:7851"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:36856 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261455AbUCaFSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 00:18:39 -0500
In-Reply-To: <1080696593.2075.120.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: axboe@suse.de, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--789163286-913007327-1080710077=:7851
Content-Type: TEXT/PLAIN; charset=US-ASCII

On 30 Mar 2004, James Bottomley wrote:

> On Mon, 2004-03-29 at 07:17, Masao Fukuchi wrote:
> > By the way, how about item 1.
> > I think this is bug and we need to validate fastfail for command timeout.
> > If you agree with this, please put it into official patch.
> > (See attached patch)
> 
> Well, the patch doesn't apply, but I put an equivalent in the tree.
> 
> > Next, I tested the fastfail recovery using Kernel 2.6.4.
> > But the command didn't complete forever.
> > Then I installed following Mike Christie's patch and it worked fine.
> >  http://marc.theaimsgroup.com/?l=linux-scsi&m=107904932710899&w=2
> > Please put it into official patch.
> 
> This patch is obviously wrong on its face.  It completes the request
> without regard to any leftovers.
> 
> There's clearly a problem somewhere in the completion path for commands
> that run out of retries, but whatever it is, this patch only covers it
> up it doesn't solve the root problem.
> 

This patch
http://marc.theaimsgroup.com/?l=linux-scsi&m=107904932710899&w=2
is correct wrt how the block layer uses hard_nr_sectors ;)

The blkdev.h comments state that hard_nr_sectors is the number
of sectors left to be completed. This is managed by the block layer
for drivers like SCSI when end_that_request_* calls
__end_that_request_first which for partial completions calls
blk_recalc_rq_sectors. This function updates hard_nr_sectors
by the completed number of bytes, so by scsi_end_request doing this:

 if (end_that_request_chunk(req, uptodate, bytes)) {
        int leftover = (req->hard_nr_sectors << 9) - bytes;

we end up with "bytes" getting subtracted twice and the final
bio not getting completed.

I know we went through that already. It is just to update
Masao/linux-scsi.

I had sent the attached patch to Jens (cc'd him)
that modifies how blk_recalc_rq_sectors uses hard_nr_sectors,
but I think it might break some other drivers that expect the
hard_nr_sectors to be updated as the request is completed.

Mike
~

--789163286-913007327-1080710077=:7851
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="hard_nr_sectors.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0403302114370.7851@dyn319701.beaverton.ibm.com>
Content-Description: fix blk_recalc_rq_sectors
Content-Disposition: attachment; filename="hard_nr_sectors.patch"

LS0tIGxpbnV4LTIuNi41LXJjMy1vcmlnL2RyaXZlcnMvYmxvY2svbGxfcndf
YmxrLmMJMjAwNC0wMy0zMCAxOTowODoxNi44NjIyMjE1MzYgLTA4MDANCisr
KyBsaW51eC0yLjYuNS1yYzMvZHJpdmVycy9ibG9jay9sbF9yd19ibGsuYwky
MDA0LTAzLTMwIDE5OjA5OjQ3LjYyNDI3MDMxNiAtMDgwMA0KQEAgLTI1Nzks
MTYgKzI1NzksMTQgQEAgdm9pZCBibGtfcmVjYWxjX3JxX3NlY3RvcnMoc3Ry
dWN0IHJlcXVlcw0KIHsNCiAJaWYgKGJsa19mc19yZXF1ZXN0KHJxKSkgew0K
IAkJcnEtPmhhcmRfc2VjdG9yICs9IG5zZWN0Ow0KLQkJcnEtPmhhcmRfbnJf
c2VjdG9ycyAtPSBuc2VjdDsNCiANCiAJCS8qDQogCQkgKiBNb3ZlIHRoZSBJ
L08gc3VibWlzc2lvbiBwb2ludGVycyBhaGVhZCBpZiByZXF1aXJlZCwNCiAJ
CSAqIGkuZS4gZm9yIGRyaXZlcnMgbm90IGF3YXJlIG9mIHJxLT5jYmlvLg0K
IAkJICovDQotCQlpZiAoKHJxLT5ucl9zZWN0b3JzID49IHJxLT5oYXJkX25y
X3NlY3RvcnMpICYmDQotCQkgICAgKHJxLT5zZWN0b3IgPD0gcnEtPmhhcmRf
c2VjdG9yKSkgew0KKwkJaWYgKHJxLT5zZWN0b3IgPD0gcnEtPmhhcmRfc2Vj
dG9yKSB7DQogCQkJcnEtPnNlY3RvciA9IHJxLT5oYXJkX3NlY3RvcjsNCi0J
CQlycS0+bnJfc2VjdG9ycyA9IHJxLT5oYXJkX25yX3NlY3RvcnM7DQorCQkJ
cnEtPm5yX3NlY3RvcnMgLT0gbnNlY3Q7DQogCQkJcnEtPmhhcmRfY3VyX3Nl
Y3RvcnMgPSBiaW9fY3VyX3NlY3RvcnMocnEtPmJpbyk7DQogCQkJcnEtPmN1
cnJlbnRfbnJfc2VjdG9ycyA9IHJxLT5oYXJkX2N1cl9zZWN0b3JzOw0KIAkJ
CXJxLT5ucl9jYmlvX3NlZ21lbnRzID0gYmlvX3NlZ21lbnRzKHJxLT5iaW8p
Ow0K
--789163286-913007327-1080710077=:7851--
