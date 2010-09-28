From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 17:24:56 -0400
Message-ID: <yq162xpa7dj.fsf@sermon.lab.mkp.net>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
	<4CA0CC38.5010804@fusionio.com> <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
	<4CA118FF.1080100@fusionio.com> <yq18w2mddav.fsf@sermon.lab.mkp.net>
	<20100927231551.GA15653@redhat.com> <4CA16F6A.1090904@fusionio.com>
	<4CA17B13.7080801@redhat.com> <20100928141545.GA21587@redhat.com>
	<20100928205741.GA22257@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20100928205741.GA22257@thunk.org> (Ted Ts'o's message of "Tue,
	28 Sep 2010 16:57:41 -0400")
Sender: linux-ext4-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: Mike Snitzer <snitzer@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Jens Axboe <jaxboe@fusionio.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:

Ted> Can we decide soon what the right thing should be?  I'm about to
Ted> release e2fsrogs 1.41.13, and if I should put in some sanity
Ted> checking code so mke2fs does something sane when it sees a 1M
Ted> physical block size, I can do that.

I don't think it's entirely clear what the "right thing" would be.

Let's ignore the 1MB block size for now. That's clearly a fluke and a
buggy device. But there are SSDs that will advertise an 8KiB physical
block size. And apparently 16KiB devices are in the pipeline.

How do we want to handle these devices? Allowing blocks bigger than the
page size is going to be painful.

So the question is whether we can tweak the filesystem layout in a way
that would alleviate the pain without having to change the filesystem
block size in the traditional sense.

At least we're talking about SSDs and arrays here. I assume the partial
block write penalty for these devices would be smaller than it is for
rotating media.

-- 
Martin K. Petersen	Oracle Linux Engineering
