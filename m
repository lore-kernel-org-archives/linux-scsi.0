From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Wed, 24 Jun 2015 01:24:12 +0800
Message-ID: <CAGnHSEkF+uXh2=wpq9dwjK8_NrjF5kqcasXeuCF_=TONu6Q7Cw@mail.gmail.com>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	<yq1616f796w.fsf@sermon.lab.mkp.net>
	<CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
	<yq1bng65te8.fsf@sermon.lab.mkp.net>
	<CAGnHSEm89yFPPTVUtbk1s84wanKK6RTY5hdZCMdbw+a+vwecDA@mail.gmail.com>
	<yq1mvzq4at7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1mvzq4at7.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 24 June 2015 at 01:03, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>
> It don't know what these "lower limits" you are talking about are.
>

[tom@localhost ~]$ sudo shred -v -n 1 /dev/sda3

[tom@localhost ~]$ sudo blkdiscard -l 512 /dev/sda3
[tom@localhost ~]$ sudo hexdump -n 4096 /dev/sda3 | head
0000000 58c7 f3b0 0f97 2a9a 2da8 7c44 11f5 7852
0000010 4f1d d19c 682b a3d8 6be9 61df 4eb3 a4ee
0000020 f28b f2f6 ef36 c244 f1b0 eadd 5ad0 c5ec
0000030 54c4 abb4 f9c3 7ca0 d807 63ad 81cd 45e6
0000040 2b30 709c 550a 5e52 6928 4468 78c9 f671
0000050 eef1 dfa7 2a6d 3150 64f8 f9a2 240d bbf4
0000060 2cff 02e0 c893 16a7 67c2 8cd9 af76 71b6
0000070 4740 83cc 5b15 3db0 64b2 1a6d 3f40 5a98
0000080 09d0 035c b5ae 2cd2 1850 ea70 7a09 0491
0000090 6b27 9d81 9d74 a087 afd9 e75a 85ea adf6

[tom@localhost ~]$ sudo blkdiscard -l 3584 /dev/sda3
[tom@localhost ~]$ sudo hexdump -n 4096 /dev/sda3 | head
0000000 58c7 f3b0 0f97 2a9a 2da8 7c44 11f5 7852
0000010 4f1d d19c 682b a3d8 6be9 61df 4eb3 a4ee
0000020 f28b f2f6 ef36 c244 f1b0 eadd 5ad0 c5ec
0000030 54c4 abb4 f9c3 7ca0 d807 63ad 81cd 45e6
0000040 2b30 709c 550a 5e52 6928 4468 78c9 f671
0000050 eef1 dfa7 2a6d 3150 64f8 f9a2 240d bbf4
0000060 2cff 02e0 c893 16a7 67c2 8cd9 af76 71b6
0000070 4740 83cc 5b15 3db0 64b2 1a6d 3f40 5a98
0000080 09d0 035c b5ae 2cd2 1850 ea70 7a09 0491
0000090 6b27 9d81 9d74 a087 afd9 e75a 85ea adf6

[tom@localhost ~]$ sudo blkdiscard -l 4096 /dev/sda3
[tom@localhost ~]$ sudo hexdump -n 4096 /dev/sda3 | head
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0001000

So when libata issue ATA commands with ranges of 65535 sectors, only
65535-(65535%8) = 65528 sectors are discarded, yet it wouldn't know
about that so the next range will start from LBA 65536. I can
workaround this by specifying --step in blkdiscard, but I think the
kernel should have a param configurable for general.

>
> What hdparm tells you is that DSM TRIM on the Intel drive supports 1
> block (512 bytes) of range payload data. Whereas the SanDisk drive
> supports a full 4KB page of range payload data (8 * 512 bytes).
>

Oh so they are not reporting garbage. That's good to know. I guess
that's why hdparm actually splits the range list I provided by
512-range per ATA command (which works) for the SanDisk drive.

>
> We did try to enable payloads bigger than 512 bytes back in the day but
> most drives that reported supporting the bigger payload actually didn't
> and all hell broke loose. So we reverted to a single sector payload for
> libata.
>
> I still have the payload patch in my SSD test branch and regularly test
> with it. But there are still drives that fail in mysterious ways with it
> in place and so far I haven't felt compelled to maintain yet another
> blacklist.
>

For now I have no problem with the single sector payload thing.
