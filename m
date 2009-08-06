From: Roland Dreier <rdreier@cisco.com>
Subject: [ofa-general] Re: sg_reset can trigger a NULL pointer dereference in
	the SRP initiator
Date: Thu, 06 Aug 2009 10:41:03 -0700
Message-ID: <ada1vnohmc0.fsf@cisco.com>
References: <e2e108260908060039x7718577yf932d8a9188fe0cb@mail.gmail.com>
	<4A7A949B.60408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <4A7A949B.60408@panasas.com> (Boaz Harrosh's message of "Thu, 06
	Aug 2009 11:30:19 +0300")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>, OpenIB <general@lists.openfabrics.org>
List-Id: linux-scsi@vger.kernel.org


 > Specifically scmnd->host_scribble can just be Zero.

I see at last, thanks!

The issue is that SRP is using host_scribble to hold an index, and index
0 is valid for us.

I guess the fix is a bit complex, but basically we should use
host_scribble to point to the request, and if we don't find a request in
reset_device we should allocate one.

It's a bit unfortunate that the SCSI midlayer bypasses queueing for the
device reset command because it means we may not have a slot in our
queue for the reset request etc but I suppose that's even more involved
to fix.

 - R.
