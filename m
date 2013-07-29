From: Stuart Foster <smf.linux@ntlworld.com>
Subject: Re: Kernel 3.10.3 "reset SuperSpeed USB device number 2 using xhci_hcd"
Date: Mon, 29 Jul 2013 17:33:29 +0100
Message-ID: <51F69959.8070409@ntlworld.com>
References: <Pine.LNX.4.44L0.1307291108460.1479-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1307291108460.1479-100000@iolanthe.rowland.org>
Sender: stable-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ed Tomlinson <edt@aei.ca>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/29/13 16:23, Alan Stern wrote:
> On Mon, 29 Jul 2013, Martin K. Petersen wrote:
>
>>>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
>>
>> Alan,
>>
>> Alan> It was introduced by commit 98dcc2946adb (SCSI: sd: Update WRITE
>> Alan> SAME heuristics).  This commit adds a call to scsi_get_vpd_page()
>> Alan> in sd_read_write_same() without first checking
>> Alan> sd_try_extended_inquiry().  As noted in the latter routine, VPD
>> Alan> inquiries will crash some devices.
>>
>> Is REPORT SUPPORTED OPERATION CODES generally safe on USB devices?
>
> Broadly speaking, practically nothing is safe on USB devices.  :-)  The
> general rule is: If Windows XP doesn't use the command then it will
> crash something.
>
> In the case of these bug reports, the scsi_report_opcode() call returns
> -EINVAL.
>
>> The reason I didn't wrap the WRITE SAME heuristics in
>> sd_try_extended_inquiry() like I have done with most of the other VPDs
>> is that there are a ton of older SPI/SAS/FC devices that support WRITE
>> SAME just fine.
>>
>>
>> Alan> As far as the stable kernels are concerned, the best thing for now
>> Alan> may simply be to revert it.
>>
>> No go. The above commit fixes issues for somebody else.
>>
>> I could add an explicit check to the sd_read_write_same() function. But
>> how about we do the following instead?
>
> Stuart and Ed, does Martin's patch fix your problem?
>
> Alan Stern
>
>
Hi Alan,

The patch is good for me.

thanks

Stuart Foster
