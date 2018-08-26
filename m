From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4/4] block: Integrity profile init function to trigger
 module loads
Date: Sun, 26 Aug 2018 15:44:31 +0200
Message-ID: <CAKv+Gu88A8OmVGV3-9YGkgNKOtCRmN70Ys2WL+F7au=NB4vydQ@mail.gmail.com>
References: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
 <20180826024006.13800-1-martin.petersen@oracle.com> <20180826024006.13800-4-martin.petersen@oracle.com>
 <CAKv+Gu92yj5Cuz36bRS7wz3Lg2srp8OFJC6QVO0UWYSjm8eEeg@mail.gmail.com> <yq1h8jh6yrk.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1h8jh6yrk.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Jeffrey Lien <Jeff.Lien@wdc.com>, David Darrington <david.darrington@wdc.com>, Christoph Hellwig <hch@infradead.org>, Jeff Furlong <jeff.furlong@wdc.com>, linux-block@vger.kernel.org, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On 26 August 2018 at 15:30, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Hi Ard,
>
>>> However, since the dependency for "crc10dif" is already satisfied,
>>> nothing is going to cause the hardware-accelerated kernel modules to
>>> get loaded.
>>
>> This is not true. All accelerated implementations based on SIMD
>> polynomial multiplication are tried to the respective CPU features
>> bits. This applies to x86, power, ARM and arm64.
>>
>> E.g., for x86 you have
>>
>> alias:          cpu:type:x86,ven*fam*mod*:feature:*0081*
>>
>> which will be matched by udev if /sys/devices/system/cpu/modalias
>> contains feature 0081, and so the modules will be loaded automatically
>> at boot.
>
> If I can avoid carrying that init callback in the block integrity code
> that will definitely make me happy. However, loading crct10dif-pclmul
> does not happen automatically for me. crc-t10dif is linked statically
> and every user of the CRC goes through that library. So nothing ever
> requests the "crct10dif" modalias and no accelerator modules are loaded.
>
> <fresh boot>
>
> # lsmod | grep crc
> crc32c_intel           24576  0
> crc_ccitt              16384  1 ipv6
>
> # modinfo crc32c_intel | grep cpu:type
> alias:          cpu:type:x86,ven*fam*mod*:feature:*0094*
>
> # modinfo crct10dif-pclmul | grep cpu:type
> alias:          cpu:type:x86,ven*fam*mod*:feature:*0081*
>
> # egrep -o "0081|0094" /sys/devices/system/cpu/modalias
> 0081
> 0094
>
> # modprobe crct10dif
> # lsmod | grep crc
> crct10dif_pclmul       16384  1
> crc32c_intel           24576  0
> crc_ccitt              16384  1 ipv6
>
> It's interesting that crc32c_intel is loaded but libcrc32c is not. That
> matches your description of how things should work. But crct10dif-pclmul
> isn't loaded and neither is crc32_pclmul:
>
> # modprobe crc32
> # lsmod | grep crc
> crc32_generic          16384  0
> crc32_pclmul           16384  0
> crc32c_intel           24576  0
> crc_ccitt              16384  1 ipv6
>

That is odd. On my Ubuntu system, both crct10dif_pclmul and
crc32_pclmul get loaded automatically.
