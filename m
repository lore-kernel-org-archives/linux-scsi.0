From: "Tucker, Greg B" <greg.b.tucker@intel.com>
Subject: RE: [PATCH RFC 2/2] iop13xx: imu scsi driver
Date: Fri, 26 Jan 2007 00:03:58 -0700
Message-ID: <9910A595EF5F194ABCC11F517D3A76A7015211E6@azsmsx415.amr.corp.intel.com>
References: <1169759754.3037.78.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42038 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030801AbXAZHEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2007 02:04:01 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1169759754.3037.78.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk, linux-scsi@vger.kernel.org

James, thank you for the corrections.  I think I can fix all of these as
suggested and resubmit a new patch shortly.

>Another thing that strikes me is on the ARM side, it looks like this is
>effectively vectoring up to a user space target ... is that true?  And
>if so, would the existing in-kernel target infrastructure be a better
>way of doing this?

No, there's no user space target.  The target is special hardware.  Or
more precisely, special communication hardware to send messages to
off-core hardware.

>> +static int imu_queuecommand(struct scsi_cmnd *scp,
>[...]
>> +	if (!imu_scsi->connection_handle) {
>> +		scp->result = (DID_RESET << 16) | (SUGGEST_RETRY << 24);
>> +		done(scp);
>> +		return SCSI_MLQUEUE_HOST_BUSY;
>> +	}
>
>Absolutely wrong.  Either you execute done() on the command and return
>zero, or you *don't* execute done on the command and return a queueing
>condition.  Doing both will lead to double completions and really
>horrible things.

I'll return zero like the previous error condition, thanks.

> ...wrong...

Other corrections greatly appreciated and I'll roll into next patch.

--Greg
