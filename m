From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] scsi: pm8001: pm8001_hwi.c:  Fix for possible null pointer
 dereference
Date: Wed, 28 May 2014 13:38:14 +0200
Message-ID: <5385CAA6.7010708@redhat.com>
References: <1400429640-11489-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <20140528112811.GD11953@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140528112811.GD11953@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: xjtuwjp@gmail.com, lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/28/2014 01:28 PM, Christoph Hellwig wrote:
> On Sun, May 18, 2014 at 06:14:00PM +0200, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
> I can't see how dev->lldd_dev would be NULL here.

The analysis program likely can't know that, the reason for this report 
it that dev->lldd_dev is tested for not being null several lines below -
http://lxr.free-electrons.com/source/drivers/scsi/pm8001/pm8001_hwi.c#L4447
So the other option is to remove this^ test.
