From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: RFC: reduce CONFIG_SCSI_CONSTANTS impact by 4k
Date: Tue, 06 Oct 2015 17:39:09 +0200
Message-ID: <878u7gm2g2.fsf@rasmusvillemoes.dk>
References: <87h9mbg6h1.fsf@rasmusvillemoes.dk>
	<20151003171437.GA20847@infradead.org>
	<87bncf1u4p.fsf@rasmusvillemoes.dk>
	<CAGRGNgXt6qt4K+O9u+Y45rZNh07X=6wh7CdCwJ4mwiYkjXyCWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGRGNgXt6qt4K+O9u+Y45rZNh07X=6wh7CdCwJ4mwiYkjXyCWA@mail.gmail.com>
	(Julian Calaby's message of "Tue, 6 Oct 2015 12:32:47 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 06 2015, Julian Calaby <julian.calaby@gmail.com> wrote:

> Hi Rasmus,
>
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 47aaccd5e68e..ccd34b0481cd 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -292,17 +292,31 @@ bool scsi_opcode_sa_name(int opcode, int service_action,
>>
>>  struct error_info {
>>         unsigned short code12;  /* 0x0302 looks better than 0x03,0x02 */
>> -       const char * text;
>> +       unsigned short size;
>>  };
>>
>>
>> +/*
>> + * There are 700+ entries in this table. To save space, we don't store
>> + * (code, pointer) pairs, which would make sizeof(struct
>> + * error_info)==16 on 64 bits. Rather, the second element just stores
>> + * the size (including \0) of the corresponding string, and we use the
>> + * sum of these to get the appropriate offset into additional_text
>> + * defined below. This approach saves 12 bytes per entry.
>> + */
>>  static const struct error_info additional[] =
>>  {
>> -#define SENSE_CODE(c, s) {c, s},
>> +#define SENSE_CODE(c, s) {c, sizeof(s)},
>>  #include "sense_codes.h"
>>  #undef SENSE_CODE
>>  };
>>
>> +static const char *additional_text =
>> +#define SENSE_CODE(c, s) s "\0"
>> +#include "sense_codes.h"
>> +#undef SENSE_CODE
>> +       ;
>> +
>>  struct error_info2 {
>>         unsigned char code1, code2_min, code2_max;
>>         const char * str;
>> @@ -364,11 +378,14 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
>>  {
>>         int i;
>>         unsigned short code = ((asc << 8) | ascq);
>> +       unsigned offset = 0;
>>
>>         *fmt = NULL;
>> -       for (i = 0; additional[i].text; i++)
>> +       for (i = 0; i < ARRAY_SIZE(additional); i++) {
>>                 if (additional[i].code12 == code)
>> -                       return additional[i].text;
>> +                       return additional_text + offset;
>> +               offset += additional[i].size;
>
> You don't seem to be accounting for the null bytes here.

Well, no, I account for the nul bytes where I define the table (the
comment actually says as much). sizeof("foo") is 4. Since
additional_text ends up pointing to a string containing

"foo" "\0" "xyzzy" "\0" "..." "\0"

aka

"foo\0xyzzy\0...\0"

this is the right amount to skip. As I said in the cover letter, I did
test this (so that I'd at least catch silly off-by-ones), and I do get
the right strings out.

Thanks,
Rasmus
