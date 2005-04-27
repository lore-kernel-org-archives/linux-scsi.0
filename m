From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/04] scsi: make scsi_send_eh_cmnd use
 its own timer instead of scmd->eh_timeout
Date: Wed, 27 Apr 2005 20:50:39 +0900
Message-ID: <426F7C8F.8010105@gmail.com>
References: <20050419143100.E231523D@htj.dyndns.org>	 <20050419143100.0F9A8C3B@htj.dyndns.org>	 <1114381342.4786.17.camel@mulgrave>  <426C2FC3.4090105@gmail.com>	 <1114452544.5000.11.camel@mulgrave>  <426EF781.6040403@gmail.com> <1114580059.5039.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.207]:19414 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261470AbVD0Luq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 07:50:46 -0400
Received: by rproxy.gmail.com with SMTP id a41so136274rng
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 04:50:44 -0700 (PDT)
In-Reply-To: <1114580059.5039.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

  Hello, James.

James Bottomley wrote:
> On Wed, 2005-04-27 at 11:22 +0900, Tejun Heo wrote:
> 
>> * A command is passed to lldd and starts execution
>> * It times out.
>> * eh runs
>> * abort isn't implemented or fails
>> * eh issues eh cmd (TUL, STU...)
>> * The command miraculously & stupidly completes just now.
> 
> 
> This should be impossible.  The error handler API requirement is that
> the driver relinquish a command once it returns success from any error
> handling callback ... and if it never returns success, we simply offline
> the device and never use it again.  This is the principle behind the
> command reuse: we only try an additional command *after* error handling
> succeeds, so the error handler now owns the command absolutely.
> 

  Hmmm, yeah, it currently cannot happen, and if what you're describing 
is a requirement, everything should be okay.  But, I still think that 
using separate timer will be better as it won't add any overhead (with 
the change you proposed) and it makes the somewhat unobivous requirement 
go away.  Or at least add BUG_ON() test or something to make the 
requirement clear.

  What do you think?

  Thanks.

-- 
tejun
