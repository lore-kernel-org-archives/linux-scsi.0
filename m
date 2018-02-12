From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: UFS writing request failure handling
Date: Mon, 12 Feb 2018 10:13:26 -0800
Message-ID: <f81bf6c9-fe46-344a-15cb-03867c9e7c6c@wdc.com>
References: <2a98182c0eed4f0d9615982dc3733024@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2a98182c0eed4f0d9615982dc3733024@SIWEX5A.sing.micron.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/12/18 04:21, Bean Huo (beanhuo) wrote:
> I am looking at UFS error handling, but I didn't notice re-issues
> requests with UTP error to the host controller. According UFS host
> spec, "host software either completes the request that had the error
> and requests still outstanding with error to higher level software,
> or re-issues these requests to the host controller". For the latest
> Linux UFS driver, it belongs to former one? If I am wrong, please
> correct me.

Hello Bean,

I'm afraid that reissuing a failed write forever could cause an infinite 
loop that makes e.g. user space processes unkillable or that could cause 
an orderly system shutdown to hang. I'm not sure that we want such behavior.

If you want to learn more about how the SCSI core handles failed writes, 
please have a look at scsi_decide_disposition(). A possible approach to 
modify the error handling behavior is to stack a dm driver on top of the 
SCSI core that implements the desired behavior.

Bart.
