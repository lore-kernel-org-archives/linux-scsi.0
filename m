From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v2 2/2] libata-scsi: do not respond with "invalid field"
 for FORMAT UNIT
Date: Wed, 6 Jul 2016 06:40:32 +0000
Message-ID: <CAGnHSEnuCTP4R1EwB0UPW1S_=GzWjbaxyKW9JK7oKGMpzyrX7w@mail.gmail.com>
References: <577b57b3.5b4c620a.37648.6c91@mx.google.com> <77f27e3b-afe6-2aa9-7d42-e054a7f65bb0@cogentembedded.com>
 <CAGnHSEm2YEA2fg93w0jDR_Jou5MhxRH30RSLUqoQc_6Fg6s-Hg@mail.gmail.com> <20160705223906.GD25394@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160705223906.GD25394@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Um it's not mainly about in caps or not, but more about wrongly spelled as cbd.

On 5 July 2016 at 22:39, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Jul 06, 2016 at 03:13:31AM +0800, Tom Yan wrote:
>> I just thought that such a minor change in a comment can fit in the
>> same patch where the issue was first noticed. Anyway, will split them
>> if I am going to send a v3 set.
>>
>> On 5 July 2016 at 19:08, Sergei Shtylyov
>> <sergei.shtylyov@cogentembedded.com> wrote:
>> > On 7/5/2016 9:45 AM, tom.ty89@gmail.com wrote:
>> >
>> >> From: Tom Yan <tom.ty89@gmail.com>
>> >>
>> >> It does not make sense and is confusing to respond with "Invalid
>> >> field in CDB" while we have no support at all implemented for
>> >> FORMAT UNIT. It is decent to let it go to the default, which
>> >> will respond with "Invalid command operation code" instead.
>> >>
>> >> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>> >>
>> >> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> >> index 029e738..ac5676e 100644
>> >> --- a/drivers/ata/libata-scsi.c
>> >> +++ b/drivers/ata/libata-scsi.c
>> >> @@ -307,7 +307,7 @@ static void ata_scsi_set_invalid_field(struct
>> >> ata_device *dev,
>> >>                                        struct scsi_cmnd *cmd, u16 field,
>> >> u8 bit)
>> >>  {
>> >>         ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x24, 0x0);
>> >> -       /* "Invalid field in cbd" */
>> >> +       /* "Invalid field in CDB" */
>> >
>> >
>> >    Don't do 2 things in one patch please> This change wasn't even documented
>> > in the patch description.
>
> So, for trivial cleanups, it's fine to do it along with other changes
> when the cleanups and the said changes are related and close by;
> however, the description should be able to encompass all changes.  It
> doesn't have to be super detailed.  Something like "While at it, do
> some trivial / typo / whatever cleanups" works fine.
>
> Here, the cleanup isn't that close.  I'd just drop that chunk.  It
> really doesn't matter whether cdb is in caps or not.
>
> Thanks.
>
> --
> tejun
