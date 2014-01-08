From: Sergey Meirovich <rathamahata@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Wed, 8 Jan 2014 16:43:07 +0200
Message-ID: <CA+QCeVQy08m9oBM1ULE_KAjd-36ao35p7-BCWErJewyr3m6NGg@mail.gmail.com>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz> <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com> <20140108140307.GA588@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140108140307.GA588@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

On 8 January 2014 16:03, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 07, 2014 at 08:37:23PM +0200, Sergey Meirovich wrote:
>> Actually my initial report (14.67Mb/sec  3755.41 Requests/sec) was about ext4
>> However I have tried XFS as well. It was a bit slower than ext4 on all
>> occasions.
>
> I wasn't trying to say XFS fixes your problem, but that we could
> implement appending AIO writes in XFS fairly easily.
>
> To verify Jan's theory, can you try to preallocate the file to the full
> size and then run the benchmark by doing a:
>
> # fallocate -l <size> <filename>
>
> and then run it?  If that's indeed the issue I'd be happy to implement
> the "real aio" append support for you as well.
>

After fallocate:
[root@illin01 ext4]# du -k test_file.* | awk '{print $1}' |sort |uniq
81920
[root@illin01 ext4]# fallocate -l 81920k test_file.*

Results are almost the same:
    14.68Mb/sec  3758.02 Requests/sec
