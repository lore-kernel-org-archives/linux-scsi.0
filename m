From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] Generic SCSI Target Middle Level for Linux (SCST)
 with target drivers
Date: Thu, 17 Jun 2004 16:15:17 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D18B55.1020704@vlnb.net>
References: <40D075DA.2000007@vlnb.net> <20040616182131.GV20511@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout.azz.ru ([81.176.67.34]:47747 "HELO mailserver.azz.ru")
	by vger.kernel.org with SMTP id S266464AbUFQMNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 08:13:31 -0400
In-Reply-To: <20040616182131.GV20511@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Jun 16, 2004 at 08:31:22PM +0400, Vladislav Bolkhovitin wrote:
> 
>>Any comments would be appreciated.
> 
> 
> The first obvious question is: Why does this need to be done in kernel
> space?  My impression was that an iSCSI target would best be done in
> userspace.
> 
The answer is quite obvious as well. There is not only iSCSI target 
(i.e. software one) in the world. For hardware targets if you were 
switch on each command (IRQ) to user space and back, it would be huge 
performance penalty, especially for commands that request small data 
transfers. Take a look on the Qlogic target: all job is done in the 
tasklet, without ever context switch. The same is for upcoming iSCSI 
hardware, like Qlogic QLA4010, which also supports target mode.

BTW, the processing is simple enough, the main SCST module is only about 
  60Kb long. The main point is that this processing must be done in 
_each_ SCSI target driver. So, consider SCSI target mid-level like a 
library (framework) for such drivers, exectly as the regular SCSI 
mid-level for regular SCSI drivers.

Thanks,
Vlad
