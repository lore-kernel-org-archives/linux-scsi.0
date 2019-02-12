From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: block: Handle cases where devices come online read-only
Date: Tue, 12 Feb 2019 11:47:12 -0500
Message-ID: <yq1d0nxuf73.fsf@oracle.com>
References: <20190208233831.31377-1-martin.petersen@oracle.com>
        <20190212080319.GA10547@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190212080319.GA10547@infradead.org> (Christoph Hellwig's
        message of "Tue, 12 Feb 2019 00:03:19 -0800")
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>, Oleksii Kurochko <olkuroch@cisco.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

>> Some devices come online in write protected state and switch to
>> read-write once they are ready to process I/O requests.
>
> That is really weird.  What kind of devices are these?

There are several. I have many bug reports, ranging from USB sticks to
arrays.

>> Note that per-partition ro settings are lost on revalidate. This has
>> been broken for at least a decade and it will require major surgery to
>> fix. To my knowledge nobody has complained about being unable to make
>> partition read-only settings stick through a revalidate. So hopefully
>> this patch will suffice as a simple fix for stable.
>
> Should we warn when we lost these settings on a revalidate?

Would be nice. But as I wrote, it's going to require major surgery to
the gendisk code to handle this particular scenario correctly since we
currently do not keep any partition state between revalidate calls.

> I have to say I don't like the tristate too much - it seems to allow
> setting a hardware write protected device writable again by user
> interfaction, right?

The original policy was that the user policy was ineffective since the
device setting always won.

Jeremy's patch allowed the user setting to override the device setting
but broke the case where devices subsequently change state at runtime.

My workaround is that the user ioctl ro state, if set, overrides
whatever the device reports. And once the user clears the flag, the
current device setting will take effect on revalidate.

> Should we just have a hardware and a user policy field that are
> separate instead?

All this needs to be completely rewritten. However, my attempt at fixing
it up properly got pretty convoluted and thus unsuitable for stable.

The intent with this patch was merely as a workaround for people stuck
with write-protected drives after boot. The tristate wasn't my first
choice, but it turned out to be the path of least resistance for a
stable fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
