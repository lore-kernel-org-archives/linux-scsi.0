From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Fri, 10 Jan 2014 19:13:11 -0800
Message-ID: <CAA9_cmdkNNfE8-b60x4ULw6OA+zxrVZoJhEX3a5XZOQKnsqfHg@mail.gmail.com>
References: <20140108005607.GB29556@linux.intel.com>
	<52CED67E.7080706@ubuntu.com>
	<11E08D716F0541429B7042699DD5C1A17073C362@FMSMSX103.amr.corp.intel.com>
	<52D0A8B4.90905@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45529 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaAKDNM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 22:13:12 -0500
In-Reply-To: <52D0A8B4.90905@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: "Brandt, Todd E" <todd.e.brandt@intel.com>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "tj@kernel.org" <tj@kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jan 10, 2014 at 6:13 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> On 01/10/2014 06:11 PM, Brandt, Todd E wrote:
>> Yes yours is simpler, but it also opens a potential memory issue
>> by passing a static int as the return location for the error value.
>> I think it's just safer to tell the callback to attempt no return
>> value at all, and for that you need to expand it into two
>> arguments, one for selection, the other for the output address.
>
> What sort of memory issue?  Also isn't there a system NULL page
> somewhere that could be used?
>

I think the static variable is ok.  We can be sure that all eh threads
are torn down before libata.ko is unloaded.
