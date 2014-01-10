From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Fri, 10 Jan 2014 00:23:03 -0500
Message-ID: <52CF83B7.90409@interlog.com>
References: <Pine.LNX.4.44L0.1401071015120.1296-100000@iolanthe.rowland.org> <52CC1FF2.1020301@ubuntu.com> <52CEEAA1.2010904@interlog.com> <52CEF68C.40703@ubuntu.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CEF68C.40703@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14-01-09 02:20 PM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 1/9/2014 1:29 PM, Douglas Gilbert wrote:
>> When REQUEST SENSE had its original semantics, TEST UNIT READY was
>> the only game in town for monitoring power management. From my
>> reading of spc4r36n.pdf section  5.1.2 "Important commands for all
>> SCSI device servers" TEST UNIT READY should be called before
>> REQUEST SENSE during device initialization (including resume). If
>> the responses to TEST UNIT READY and REQUEST SENSE contradict then
>> the former is correct.
>
> I don't see language there remotely like that.  How did you arrive at
> this conclusion?

I'm wasting my time.

>> There are SCSI devices out caught in that transition. For example
>> with sg_format I monitor progress with either TEST UNIT READY or
>> REQUEST SENSE, defaulting to the former. [Progress indication is
>> another new role for REQUEST SENSE.]
>>
>> Note that the billion or so USB keys out there that say that they
>> comply with SCSI-2 should respond to a REQUEST SENSE with its
>> original semantics.
>
> Then they will return 0/0/0, so we will assume they are up and
> running, which is correct.  SPC-2 is coming up on 13 years old and
> listed this usage for REQUEST SENSE.  Are there any actual disk drives
> out there ( and still in use ) that return 0/0/0 when in the stopped
> state?  I can't imagine there would be.
>
>> The ATA REQUEST SENSE DATA EXT command refers to the SPC-4
>> "standard" (not yet it ain't) which is naturally the new SCSI
>> semantics of REQUEST SENSE. I believe the ATA REQUEST SENSE DATA
>> EXT command is a relatively new ATA command so it does not carry
>> the historical baggage of its SCSI counterpart.
>
> It is also only for ATAPI devices.

It is a command in the "Sense Data Reporting feature set"
which is optional for ATA devices and "P" as in
"Prohibited" for ATAPI devices. See the Feature set summary
table.

You had me fooled: I thought you had some knowledge of
the ATA command set. Thanks for proving me wrong.

EOF
Doug Gilbert


