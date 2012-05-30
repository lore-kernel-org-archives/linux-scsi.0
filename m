From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 0/4] fix / cleanup async scsi scanning
Date: Wed, 30 May 2012 11:29:23 -0700
Message-ID: <CABE8wwsw98KZS0W1sJghzrei0mSGLiMoh+7Wn5xOzdM54qiYqA@mail.gmail.com>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
	<20120530182239.GD15635@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120530182239.GD15635@x1.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mroos@linux.ee, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

On Wed, May 30, 2012 at 11:22 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 30, 2012 at 11:21:25AM -0700, Dan Williams wrote:
>> Commit a7a20d10 "[SCSI] sd: limit the scope of the async probe domai=
n"
>> introduces a boot regression by moving sd probe work off of the glob=
al
>> async queue. =A0Using a local async domain hides the probe work from=
 being
>> synchronized by wait_for_device_probe()->async_synchronize_full().
>>
>> Fix this by teaching async_synchronize_full() to flush all async wor=
k
>> regardless of domain, and take the opportunity to convert scsi scann=
ing
>> to async_schedule(). =A0This enables wait_for_device_probe() to flus=
h scsi
>> scanning work.
>
> Looks like those fix a similar boot issue I reported earlier:
>
> http://marc.info/?l=3Dlinux-kernel&m=3D133839683405526&w=3D2
>
> Should I give them a run or are they still in review?
>

They're ready for a run, but are likely 3.6 material.  For 3.5 I think
James is going with the smaller fix posted here:

http://marc.info/?l=3Dlinux-scsi&m=3D133796775807498&w=3D2

--
Dan
