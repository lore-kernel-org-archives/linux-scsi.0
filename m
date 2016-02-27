From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 3/3] scsi: allow scsi devices to use direct complete
Date: Sat, 27 Feb 2016 10:38:57 +0200
Message-ID: <20160227083857.GY1770@lahna.fi.intel.com>
References: <1456359748-22838-1-git-send-email-dbasehore@chromium.org>
 <1456359748-22838-3-git-send-email-dbasehore@chromium.org>
 <20160227072641.GX1770@lahna.fi.intel.com>
 <CAGAzgsoAiL0Xmqi3gzNyuQ6kf47UiEsO3V6-WMgkd5-Wu2y42Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGAzgsoAiL0Xmqi3gzNyuQ6kf47UiEsO3V6-WMgkd5-Wu2y42Q@mail.gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 27, 2016 at 12:10:03AM -0800, dbasehore . wrote:
> A device is not able to use direct complete if its children do not
> also use direct complete. Even though the SCSI layer leaves devices
> runtime suspended, the way it does it still prevents its parent from
> using direct complete.

Okay.

Do you need to provide ->complete() hook that then resumes the device
when system is resumed (since the device resume hook is never called
when direct_complete is set)? Along the lines of
pm_complete_with_resume_check().
