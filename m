From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Mon, 04 Feb 2013 22:27:44 +0800
Message-ID: <510FC560.6020002@intel.com>
References: <Pine.LNX.4.44L0.1302021003390.25931-100000@netrider.rowland.org> <510E025A.9000103@intel.com> <CAGAzgsqMhO9nppbooY5E2H5MXZ6VcCXR-P8S=nD7_7QJYrtmdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGAzgsqMhO9nppbooY5E2H5MXZ6VcCXR-P8S=nD7_7QJYrtmdw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <JBottomley@parallels.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/04/2013 08:07 AM, dbasehore . wrote:
> On the topic that we do a fast return for both scsi and ata. Now I
> don't remember everything about this (and correct me if I'm wrong)
> since I figured this out a few months ago.
>
> There are some dependencies that scsi has on the resume path of ata. I
> think it's that before we can send the command to spin up the disk, we
> need to wait for the ata host controller to come up. As Aaron Lu
> pointed out, it takes seconds for the ata port to resume. On the hand,

I just did some more recording, the result is:
host controller takes 1ms or less to resume;
port reset takes the most time, almost the same as the whole port resume
callback, 2-4 seconds;
sd resume callback takes 16ms.

So for ata disks, the most time consuming part is in port's reset
routine, which is executed in port's resume callback.

-Aaron
