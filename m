From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [LSF/MM ATTEND] iSCSI/iSER MQ + EXTENDED_COPY host support
Date: Thu, 08 Jan 2015 18:11:25 -0500
Message-ID: <54AF0E9D.30204@interlog.com>
References: <1420665695.12144.62.camel@haakon3.risingtidesystems.com> <54ADAF09.8050405@interlog.com> <54AED355.5030705@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54AED355.5030705@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lsf-pc <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 15-01-08 01:58 PM, Andy Grover wrote:
> On 01/07/2015 02:11 PM, Douglas Gilbert wrote:
>> T10 have now dropped the LID1 and LID4 stuff (its the length
>> of the LIST IDENTIFIER field: 1 byte or 4 bytes) by obsoleting
>> all LID1 variants in SPC-5 revision 01. So the LID1 variants
>> are now gone and the LID4 appendage is dropped from the remaining
>> commands.
>>
>> Obviously LID1 based XCOPY support is important for backward
>> compatibility (back to SPC-2) but for the future maybe you might
>> consider adding the equivalent LID4 support for a basic XCOPY.
>> For example it means using the 3PC VPD page instead of the
>> RECEIVE COPY RESULTS(operating parameters) command. I believe
>> FreeNAS now supports both LID1 and LID4 variants of a basic
>> XCOPY (plus a restricted version of ODX without snapshots).
>
> Hi Doug,
>
> I was trying to learn more about ODX and saw this page:
>
> http://msdn.microsoft.com/en-us/library/windows/desktop/hh848056%28v=vs.85%29.aspx
>
> but it just muddied the waters for me. Is ODX proprietary to MS, or is it XCopy
> lite, or what? And what's the difference between xcopy lite and LID4 XCOPY?

Andy,
XCOPY is huge and keeps getting bigger (apart from the recent
trimming of the "LID1" generation mentioned above). Most SCSI
commands are sent to the LU involved, but for EXTENDED COPY
command itself, should it be sent to the source or destination
of the copy, or another LU which acts as a third party copy
manager? Also when you examine the parameter block associated
with the EXTENDED COPY command, one starts thinking there
must be a cleaner and simpler way.

In the real world VMware have been using the basic disk->disk
XCOPY for around 10 years. Their usage seems to be dominant in
the market place.

While the LID4 rewrite/additions were occurring at T10 in 2011,
a proposal was made to simplify things with a two step,
disk-to-disk copy. The glue between those two steps is a token.
The first step (POPULATE TOKEN) is sent to the copy source **,
the second step is sent to the copy destination (WRITE USING
TOKEN). The document is called:
        XCOPYv2: Extended Copy Plus & Lite
[11-077R1 at www.t10.org] and is worth looking at. The
"Bucket Of Bytes" (BOB) in that document has become the
"Representation Of Data" (ROD) found in T10 documents today.

Commercially MS and NetApp (seemingly) were behind this
new approach. And MS christened it ODX which is found in their
recent OS products.


I have written this page about the ddpt utility's
implementation of these two disk-to-disk copy approaches:
   http://sg.danny.cz/sg/ddpt_xcopy_odx.html

Doug Gilbert


** and as NAB pointed out a "point-in-time" copy (snapshot)
    is done in this step, with the copy output going to the
    ROD. A ROD token can be thought of as a 512 byte long
    "pointer" to a ROD. That snapshot is a complex and
    resource consuming action for an implementation and may
    explain why ODX isn't high on NAB's todo list.
    FreeNAS's implementation cuts a corner here and just
    holds the gather-list in the ROD. That seems to violate
    SBC-3's description but is allowed by SPC-4. Any language
    lawyers like to comment?
