From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Tue, 22 May 2018 16:41:24 -0700
Message-ID: <0afffef1-9908-a446-436c-0189b1de64e1@infradead.org>
References: <20180522181512.39316-1-keescook@chromium.org>
 <20180522181512.39316-4-keescook@chromium.org>
 <20180522183613.GA3784@infradead.org> <yq1efi3bk3g.fsf@oracle.com>
 <CAGXu5jJ0Sice+fdpWgzBhQR=NGz-DT9qmYVdV1GeH73_q9pbmw@mail.gmail.com>
 <732f4249-5681-4a54-ec21-4ecc3d3a74e5@kernel.dk>
 <20180522191309.GA23615@infradead.org>
 <8d4af5c4-96fa-54ee-d5c1-b887b1de5a3c@kernel.dk>
 <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
 <66701f74-4f2b-988e-dd48-a2140694f551@infradead.org>
 <CAGXu5jJ-+F_a2Vah8JAVvfQ5Jo6mBQOoZF05da3syxhcrJoMtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJ-+F_a2Vah8JAVvfQ5Jo6mBQOoZF05da3syxhcrJoMtQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/22/2018 04:39 PM, Kees Cook wrote:
> On Tue, May 22, 2018 at 4:34 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 05/22/2018 04:31 PM, Kees Cook wrote:
>>> On Tue, May 22, 2018 at 12:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 5/22/18 1:13 PM, Christoph Hellwig wrote:
>>>>> On Tue, May 22, 2018 at 01:09:41PM -0600, Jens Axboe wrote:
>>>>>> I think Martin and Christoph are objecting to moving the code to
>>>>>> block/scsi_ioctl.h. I don't care too much about where the code is, but
>>>>>> think it would be nice to have the definitions in a separate header. But
>>>>>> if they prefer just pulling in all of SCSI for it, well then I guess
>>>>>> it's pointless to move the header bits. Seems very heavy handed to me,
>>>>>> though.
>>>>>
>>>>> It might be heavy handed for the 3 remaining users of drivers/ide,
>>>>
>>>> Brutal :-)
>>>
>>> Heh. I noticed a similar sense buffer use in drivers/cdrom/cdrom.c
>>> too. Is this okay under the same considerations?
>>
>> No.  Do not select an entire subsystem.  Use depends on it instead.
> 
> I looked at that first, but it seems it's designed for that. For
> example, "config ATA" already has a "select SCSI".
> 
> It does look fishy, though, since "config SCSI" has a "depends" which
> would be ignored by "select". Luckily, all these uses already do a
> "depends on BLOCK" (directly or indirectly).

Linus has railed against selecting subsystems.  We shouldn't be adding
more IMHO, although it is difficult to get rid of ones that we already have.


-- 
~Randy
