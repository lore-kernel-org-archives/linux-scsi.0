From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] sbitmap, scsi/target: add seq_file forward declaration
Date: Fri, 6 Jul 2018 22:18:30 +0200
Message-ID: <CAK8P3a35Z1Wbn0VAF5rfzBfA9ruWnjZ5ZPkPhRYaQnaZv1ejtA@mail.gmail.com>
References: <20180706132407.4069001-1-arnd@arndb.de> <47d87d9ca498687344fcb18067ffe5e7bc313616.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <47d87d9ca498687344fcb18067ffe5e7bc313616.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>, "willy@infradead.org" <willy@infradead.org>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 6, 2018 at 7:07 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Fri, 2018-07-06 at 15:23 +0200, Arnd Bergmann wrote:
>> The target core runs into a warning in the linux/sbitmap.h
>> file in some configurations:
>>
>> In file included from include/target/target_core_base.h:7,
>>                  from drivers/target/target_core_fabric_lib.c:41:
>> include/linux/sbitmap.h:331:46: error: 'struct seq_file' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
>>  void sbitmap_show(struct sbitmap *sb, struct seq_file *m);
>>                                               ^~~~~~~~
>>
>> In general, headers should not depend on others being included first,
>> so this fixes it with a forward declaration for that struct name, but
>> we probably want to merge the patch through the scsi tree to help
>> bisection.
>>
>> Fixes: 10e9cbb6b531 ("scsi: target: Convert target drivers to use sbitmap")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  include/linux/sbitmap.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
>> index e6539536dea9..cc54b9f7ff8b 100644
>> --- a/include/linux/sbitmap.h
>> +++ b/include/linux/sbitmap.h
>> @@ -321,6 +321,8 @@ static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
>>
>>  unsigned int sbitmap_weight(const struct sbitmap *sb);
>>
>> +struct seq_file;
>> +
>>  /**
>>   * sbitmap_show() - Dump &struct sbitmap information to a &struct seq_file.
>>   * @sb: Bitmap to show.
>
> In many Linux kernel header files all forward declarations are grouped near
> the start of the header file (after #includes and #defines and before structure
> definitions). Should we follow that pattern in <linux/sbitmap.h>?

I couldn't find any other such declaration in this header, so I just put it
close to where it's first used, which is the other common way to do it.
I checked all of include/linux and found that you are right, a clear
majority of the headers just pull all struct declarations in the front.

     Arnd
